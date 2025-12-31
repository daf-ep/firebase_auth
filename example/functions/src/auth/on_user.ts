import * as admin from 'firebase-admin';
import { onValueCreated, onValueDeleted } from "firebase-functions/v2/database";
import { DatabaseEncoder } from '../common/database';
import { APP_NAME, HOSTING_URL_DOMAIN } from '../config/params';
import { mailBox } from '../mailbox/mail_box';
import { newUserTemplate } from '../mailbox/templates/new_user';

type LanguageKey = keyof typeof newUserTemplate;

if (admin.apps.length === 0) {
  admin.initializeApp();
}

export const onUserCreated = onValueCreated(
  "/users/{userId}",
  async (event) => {
    const userId = event.params.userId;
    if (!userId) return;

    const data = event.data?.val();
    if (!data) return;

    const email = data.email;
    if (!email) return;

    await admin.database().ref(`/emails/${DatabaseEncoder.encode(email)}`).set(userId);

    const rawLanguage = data.preferred_language?.current;
    const language: LanguageKey = rawLanguage && rawLanguage in newUserTemplate ? rawLanguage : "english";
    const template = newUserTemplate[language] ?? newUserTemplate.english;
    const appName = APP_NAME.value();
    const hostingUrlDomain = HOSTING_URL_DOMAIN.value();
    const verifyLink = await admin.auth().generateEmailVerificationLink(email, { url: hostingUrlDomain + "/verify-email.html?lang=" + language, handleCodeInApp: true });

    const parsedUrl = new URL(verifyLink);
    const oobCode = parsedUrl.searchParams.get("oobCode");
    const url = hostingUrlDomain + "/verify-email.html?oobCode=" + oobCode + "&lang=" + language;

    await mailBox({ to: email, subject: template.subject, text: template.text("", appName, url) });
  }
);

export const onUserDeleted = onValueDeleted(
  "/users/{userId}",
  async (event) => {
    const userId = event.params.userId;
    if (!userId) return;

    const data = event.data?.val();
    if (!data) return;

    const email = data.email;
    if (!email) return;

    await admin
      .database()
      .ref(`/emails/${DatabaseEncoder.encode(email)}`)
      .remove();
  }
);