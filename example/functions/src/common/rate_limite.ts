import * as admin from 'firebase-admin';

if (admin.apps.length === 0) {
    admin.initializeApp();
}

export enum RateLimitFeature {
    NewDeviceDetected = "new_device_detected",
    NewDeviceOtpRequest = "new_device_otp_request",
    ResetPassword = "reset_password",
}

export async function setRateLimit(params: {
    feature: RateLimitFeature;
}): Promise<void> {
    const { feature } = params;

    if (!feature) {
        throw new Error("INVALID_MAIL_PARAMS");
    }
}