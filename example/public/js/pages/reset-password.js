import { getAuth } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-auth.js";
import { S } from "../../i18n/i18n.js";
import { app } from "../common/firebase.js";

const auth = getAuth(app);

const params = new URLSearchParams(window.location.search);
const oobCode = params.get("oobCode");

const root = document.documentElement;

const title = document.getElementById("title");
const subtitle = document.getElementById("subtitle");

const new_password_label = document.getElementById("new_password_label");
const confirm_new_password_label = document.getElementById("confirm_new_password_label");

const update_button = document.getElementById("update_button");

title.textContent = S("password_reset_title");
subtitle.textContent = S("password_reset_subtitle");

new_password_label.textContent = S("new_password");
confirm_new_password_label.textContent = S("confirm_password");

update_button.textContent = S("update");

// const footerMessage = document.getElementById("footer_message");

// function showIcon(type) {
//     iconSuccess.classList.remove("is-visible");
//     iconWarning.classList.remove("is-visible");
//     iconError.classList.remove("is-visible");

//     if (type === "success") iconSuccess.classList.add("is-visible");
//     if (type === "warning") iconWarning.classList.add("is-visible");
//     if (type === "error") iconError.classList.add("is-visible");
// }

// function setFeedbackColor(type) {
//     const map = {
//         success: "var(--color-feedback-success)",
//         warning: "var(--color-feedback-warning)",
//         info: "var(--color-feedback-info)",
//         error: "var(--color-feedback-error)",
//     };

//     root.style.setProperty("--feedback-color", map[type]);
// }

// function showState(type) {
//     showIcon(type);
//     setFeedbackColor(type);
// }

// if (!oobCode) {
//     showState("error");

//     title.textContent = S("verify_email_missing_title");
//     subtitle.textContent = S("verify_email_missing_subtitle");
//     footerMessage.textContent = S("verify_email_missing_footer");

// } else {
//     try {
//         await applyActionCode(auth, oobCode);

//         showState("success");

//         title.textContent = S("verify_email_success_title");
//         subtitle.textContent = S("verify_email_success_subtitle");
//         footerMessage.textContent = S("verify_email_success_footer");

//     } catch (err) {
//         showState("warning");

//         title.textContent = S("verify_email_expired_title");
//         subtitle.textContent = S("verify_email_expired_subtitle");
//         footerMessage.textContent = S("verify_email_expired_footer");
//     }
// }