import * as admin from 'firebase-admin';
import { onCall } from 'firebase-functions/https';
import { HOSTING_URL_DOMAIN } from '../../config/params';
import { mailBox } from '../../mailbox/mail_box';
import { resetPasswordTemplate } from '../../mailbox/templates/reset_password';

type LanguageKey = keyof typeof resetPasswordTemplate;

if (admin.apps.length === 0) {
    admin.initializeApp();
}

export const resetPassword = onCall(async (request) => {
    const email = request.data?.email as string | undefined;

    if (!email) return false;

    let user;
    try {
        user = await admin.auth().getUserByEmail(email);
    } catch {
        return true;
    }

    const uid = user.uid;
    const userSnap = await admin.database().ref(`/users/${uid}`).get();

    const rawLanguage = userSnap.exists() ? userSnap.val()?.preferred_language?.current : null;
    const language: LanguageKey = rawLanguage && rawLanguage in resetPasswordTemplate ? rawLanguage : 'english';

    const template = resetPasswordTemplate[language];
    const hostingUrlDomain = HOSTING_URL_DOMAIN.value();

    const resetLink = await admin.auth().generatePasswordResetLink(email, {
        url: `${hostingUrlDomain}/reset-password.html?lang=${language}`,
        handleCodeInApp: true,
    });

    const parsedUrl = new URL(resetLink);
    const oobCode = parsedUrl.searchParams.get('oobCode');

    if (!oobCode) return true;

    const url = `${hostingUrlDomain}/reset-password.html?oobCode=${oobCode}&lang=${language}`;

    await mailBox({ to: email, subject: template.subject, text: template.text(url) });

    return true;
});