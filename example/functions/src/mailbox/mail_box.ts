import * as admin from "firebase-admin";

if (admin.apps.length === 0) {
    admin.initializeApp();
}

export async function mailBox(params: {
    to: string | string[];
    subject: string;
    text: string;
}): Promise<void> {
    const { to, subject, text } = params;

    if (!to || !subject || !text) {
        throw new Error("INVALID_MAIL_PARAMS");
    }

    await admin.firestore().collection("mailbox").add({
        to: Array.isArray(to) ? to : [to],
        message: {
            subject,
            text,
        },
    });
}