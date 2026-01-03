import * as crypto from 'crypto';
import * as admin from 'firebase-admin';
import { HttpsError, onCall } from 'firebase-functions/https';
import { DatabaseEncoder } from '../../common/database';
import { mailBox } from '../../mailbox/mail_box';
import { newDeviceDectedTemplate } from '../../mailbox/templates/new_device_detected';
import { peekIsRateLimited, RateLimiter } from '../rate_limite';

type LanguageKey = keyof typeof newDeviceDectedTemplate;

if (admin.apps.length === 0) {
    admin.initializeApp();
}

function genotp(): { otp: string; hash: string; salt: string; } {
    const otp = crypto.randomInt(100000, 1000000).toString();
    const salt = crypto.randomBytes(16);

    const hash = crypto
        .scryptSync(otp, salt, 64, { cost: 16384, blockSize: 8 })
        .toString("hex");

    return { otp, hash, salt: salt.toString("hex") };
}

export const askNewDeviceDectectedOtp = onCall(async (request) => {
    const email = request.data?.email as string | undefined;
    const deviceId = request.data?.deviceId as string | undefined;

    if (!email || !deviceId) return { isLimited: false, success: false };

    const limited = await peekIsRateLimited({
        rateLimiter: RateLimiter.NewDeviceOtpRequest,
        key: deviceId,
    });

    if (limited) return { isLimited: true, success: false };

    const otpRef = admin
        .database()
        .ref(`/otps/${DatabaseEncoder.encode(email)}`);

    const otpSnap = await otpRef.get();
    if (otpSnap.exists()) {
        await otpRef.remove();
    }

    const userRecord = await admin.auth().getUserByEmail(email);
    const uid = userRecord.uid;

    const userSnap = await admin.database().ref(`/users/${uid}`).get();
    if (!userSnap.exists()) return { isLimited: false, success: false };

    const user = userSnap.val();
    const rawLanguage = user.preferred_language?.current;

    const language: LanguageKey =
        rawLanguage && rawLanguage in newDeviceDectedTemplate
            ? rawLanguage
            : "english";

    const template = newDeviceDectedTemplate[language];

    const { otp, hash, salt } = genotp();

    await otpRef.set({ hash, salt, created_at: Date.now(), device_id: deviceId });
    await mailBox({ to: email, subject: template.subject, text: template.text(otp) });

    return { isLimited: false, success: true };
});

export const verifyNewDeviceDetectedOtp = onCall(async (request) => {
    const email = request.data?.email as string | undefined;
    const deviceId = request.data?.deviceId as string | undefined;
    const otp = request.data?.otp as string | undefined;

    if (!email || !deviceId || !otp) {
        throw new HttpsError("invalid-argument", "MISSING_PARAMS");
    }

    const limited = await peekIsRateLimited({
        rateLimiter: RateLimiter.NewDeviceOtpRequest,
        key: deviceId,
    });

    if (limited) {
        throw new HttpsError("resource-exhausted", "RATE_LIMIT_EXCEEDED");
    }

    const otpRef = admin
        .database()
        .ref(`/otps/${DatabaseEncoder.encode(email)}`);

    const snapshot = await otpRef.get();
    if (!snapshot.exists()) {
        throw new HttpsError("not-found", "OTP_NOT_FOUND");
    }

    const data = snapshot.val();

    if (data.device_id !== deviceId) {
        throw new HttpsError("permission-denied", "DEVICE_MISMATCH");
    }

    const OTP_TTL = 15 * 60 * 1000;
    if (!data.created_at || Date.now() - data.created_at > OTP_TTL) {
        await otpRef.remove();
        throw new HttpsError("deadline-exceeded", "OTP_EXPIRED");
    }

    if (!data.hash || !data.salt) {
        throw new HttpsError("internal", "OTP_INVALID_STATE");
    }

    const salt = Buffer.from(data.salt, "hex");
    const computedHash = crypto
        .scryptSync(otp, salt, 64, { cost: 16384, blockSize: 8 })
        .toString("hex");

    if (computedHash !== data.hash) {
        throw new HttpsError("permission-denied", "INVALID_OTP");
    }

    await otpRef.remove();

    return { success: true };
});