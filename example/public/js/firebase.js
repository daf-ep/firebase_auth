import { initializeApp } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-app.js";
import { Params } from "../config/params.js";

const firebaseConfig = {
  apiKey: Params["firebase"]["apiKey"],
  authDomain: Params["firebase"]["authDomain"],
};

export const app = initializeApp(firebaseConfig);