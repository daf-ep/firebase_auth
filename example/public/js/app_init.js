import { Params } from "../config/params.js";
import { LANG_CODE, S } from "../i18n/i18n.js";

document.documentElement.lang = LANG_CODE;
document.documentElement.dir = ["ar", "he"].includes(LANG_CODE) ? "rtl" : "ltr";

const isVerifyEmailPage = window.location.pathname.endsWith("/verify-email.html");

if (isVerifyEmailPage) {
    document.title = `${Params.app.name} - ${S("email_verification")}`;
}