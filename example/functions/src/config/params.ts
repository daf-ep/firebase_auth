import { defineString } from "firebase-functions/params";

export const HOSTING_URL_DOMAIN = defineString("HOSTING_URL_DOMAIN", { default: "https://your-domain" });
export const APP_NAME = defineString("APP_NAME", { default: "MyApp" });