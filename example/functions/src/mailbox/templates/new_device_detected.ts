export const newDeviceDectedTemplate = {
    arabic: {
        subject: "تأكيد تسجيل الدخول من جهاز جديد",
        text: (otp: string) => `مرحبًا،\n\nلقد اكتشفنا محاولة لتسجيل الدخول إلى حسابك من جهاز جديد.\n\nللتأكد من أنك أنت من يقوم بهذه العملية، يرجى إدخال رمز التحقق التالي:\n\n${otp}\n\nستنتهي صلاحية هذا الرمز خلال 15 دقيقة.\n\nإذا لم تكن أنت من قام بهذه المحاولة، نوصي بتغيير كلمة المرور الخاصة بك فورًا والتواصل مع فريق الدعم لدينا.\n\nشكرًا لحسن تعاونك،\nفريق الدعم`
    },
    bulgarian: {
        subject: 'Потвърждение на вход от ново устройство',
        text: (otp: String) => `Здравейте,\n\nЗабелязахме опит за влизане във вашия акаунт от ново устройство.\n\nЗа да потвърдим, че това сте вие, моля въведете следния код за потвърждение:\n${otp}\n\nТози код ще изтече след 15 минути.\n\nАко не вие сте направили тази заявка, препоръчваме незабавно да промените паролата си и да се свържете с нашия екип за поддръжка.\n\nБлагодарим ви за вниманието,\nЕкипът за поддръжка`
    },
    catalan: {
        subject: 'Confirmació d’inici de sessió des d’un nou dispositiu',
        text: (otp: String) => `Hola,\n\nHem detectat un intent d’inici de sessió al teu compte des d’un nou dispositiu.\n\nPer verificar que ets tu, introdueix el següent codi de verificació:\n${otp}\n\nAquest codi caducarà en 15 minuts.\n\nSi no has estat tu qui ha iniciat aquesta acció, et recomanem que canviïs la teva contrasenya immediatament i que contactis amb el nostre equip de suport.\n\nGràcies per la teva col·laboració,\nL’equip de suport`
    },
    chinese: {
        subject: '来自新设备的登录确认',
        text: (otp: String) => `您好，\n\n我们检测到有人试图通过一台新设备登录您的账户。\n\n为确认是您本人操作，请输入以下验证码：\n${otp}\n\n此验证码将在15分钟后过期。\n\n如果这不是您本人操作，我们建议您立即更改密码，并联系技术支持团队。\n\n感谢您的配合，\n技术支持团队`
    },
    croatian: {
        subject: 'Potvrda prijave s novog uređaja',
        text: (otp: String) => `Pozdrav,\n\nOtkrili smo pokušaj prijave na vaš račun s novog uređaja.\n\nKako bismo potvrdili da ste to vi, molimo unesite sljedeći sigurnosni kod:\n${otp}\n\nOvaj kod istječe za 15 minuta.\n\nAko to niste bili vi, preporučujemo da odmah promijenite svoju lozinku i kontaktirate naš tim za podršku.\n\nHvala na vašoj pažnji,\nTim za podršku`
    },
    czech: {
        subject: 'Potvrzení přihlášení z nového zařízení',
        text: (otp: String) => `Dobrý den,\n\nZaznamenali jsme pokus o přihlášení k vašemu účtu z nového zařízení.\n\nPro ověření, že se jedná o vás, zadejte prosím následující ověřovací kód:\n${otp}\n\nTento kód vyprší za 15 minut.\n\nPokud jste to nebyli vy, doporučujeme okamžitě změnit své heslo a kontaktovat náš tým podpory.\n\nDěkujeme za vaši pozornost,\nTým podpory`
    },
    danish: {
        subject: 'Bekræftelse af login fra en ny enhed',
        text: (otp: String) => `Hej,\n\nVi har registreret et loginforsøg på din konto fra en ny enhed.\n\nFor at bekræfte, at det er dig, bedes du indtaste følgende bekræftelseskode:\n${otp}\n\nDenne kode udløber om 15 minutter.\n\nHvis det ikke var dig, anbefaler vi, at du straks ændrer din adgangskode og kontakter vores supportteam.\n\nTak for din opmærksomhed,\nSupportteamet`
    },
    dutch: {
        subject: 'Bevestiging van inloggen vanaf een nieuw apparaat',
        text: (otp: String) => `Hallo,\n\nWe hebben een poging tot inloggen op uw account vanaf een nieuw apparaat gedetecteerd.\n\nOm te bevestigen dat u dit bent, voert u alstublieft de volgende verificatiecode in:\n${otp}\n\nDeze code verloopt over 15 minuten.\n\nAls u dit niet was, wijzig dan onmiddellijk uw wachtwoord en neem contact op met ons ondersteuningsteam.\n\nBedankt voor uw waakzaamheid,\nHet ondersteuningsteam`
    },
    english: {
        subject: 'Login confirmation from a new device',
        text: (otp: String) => `Hello,\n\nWe’ve detected a login attempt to your account from a new device.\n\nTo confirm that this was you, please enter the following verification code:\n${otp}\n\nThis code will expire in 15 minutes.\n\nIf this wasn’t you, please change your password immediately and contact our support team.\n\nThank you for your vigilance,\nThe Support Team`
    },
    finnish: {
        subject: 'Salasanan palautuskoodi',
        text: (otp: String) => `Hei,\n\nOlet pyytänyt salasanasi palauttamista.\n\nVahvistuskoodisi on: ${otp}\n\nTämä koodi vanhenee 15 minuutin kuluttua.\n\nJos et pyytänyt tätä, voit jättää sähköpostin huomiotta.\n\nYstävällisin terveisin,\nTukitiimi`
    },
    french: {
        subject: 'Confirmation de connexion depuis un nouvel appareil',
        text: (otp: String) => `Bonjour,\n\nNous avons détecté une tentative de connexion à votre compte depuis un nouvel appareil.\n\nPour vérifier qu’il s’agit bien de vous, merci d’entrer le code de vérification suivant :\n${otp}\n\nCe code expirera dans 15 minutes.\n\nSi vous n’êtes pas à l’origine de cette tentative, nous vous conseillons de modifier votre mot de passe immédiatement et de contacter notre équipe support.\n\nMerci de votre vigilance,\nL’équipe support`
    },
    german: {
        subject: 'Bestätigung der Anmeldung von einem neuen Gerät',
        text: (otp: String) => `Hallo,\n\nWir haben einen Anmeldeversuch bei Ihrem Konto von einem neuen Gerät festgestellt.\n\nUm zu bestätigen, dass Sie es sind, geben Sie bitte den folgenden Bestätigungscode ein:\n${otp}\n\nDieser Code läuft in 15 Minuten ab.\n\nWenn Sie das nicht waren, ändern Sie bitte sofort Ihr Passwort und kontaktieren Sie unser Support-Team.\n\nVielen Dank für Ihre Aufmerksamkeit,\nDas Support-Team`
    },
    greek: {
        subject: 'Επιβεβαίωση σύνδεσης από νέα συσκευή',
        text: (otp: String) => `Γειά σας,\n\nΕντοπίσαμε μια προσπάθεια σύνδεσης στον λογαριασμό σας από νέα συσκευή.\n\nΓια να επιβεβαιώσουμε ότι είστε εσείς, παρακαλούμε εισαγάγετε τον ακόλουθο κωδικό επιβεβαίωσης:\n${otp}\n\nΑυτός ο κωδικός θα λήξει σε 15 λεπτά.\n\nΑν δεν ήσασταν εσείς, αλλάξτε αμέσως τον κωδικό πρόσβασής σας και επικοινωνήστε με την ομάδα υποστήριξής μας.\n\nΣας ευχαριστούμε για την προσοχή σας,\nΗ ομάδα υποστήριξης`
    },
    hebrew: {
        subject: "אישור כניסה ממכשיר חדש",
        text: (otp: string) => `שלום,\n\nזיהינו ניסיון כניסה לחשבונך ממכשיר חדש.\n\nכדי לוודא שמדובר בך, אנא הזן את קוד האימות הבא:\n\n${otp}\n\nתוקף הקוד יפוג בעוד 15 דקות.\n\nאם לא אתה ביצעת את הניסיון, אנו ממליצים לשנות את הסיסמה שלך מיד ולפנות לצוות התמיכה שלנו.\n\nתודה על שיתוף הפעולה,\nצוות התמיכה`
    },
    hindi: {
        subject: 'नए डिवाइस से लॉगिन की पुष्टि करें',
        text: (otp: String) => `नमस्ते,\n\nहमने आपके खाते में एक नए डिवाइस से लॉगिन करने का प्रयास पाया है।\n\nयदि यह आप ही हैं, तो कृपया नीचे दिया गया सत्यापन कोड दर्ज करें:\n${otp}\n\nयह कोड 15 मिनट में समाप्त हो जाएगा।\n\nयदि यह आप नहीं थे, तो कृपया तुरंत अपना पासवर्ड बदलें और हमारी सहायता टीम से संपर्क करें।\n\nसतर्कता बरतने के लिए धन्यवाद,\nसहायता टीम`
    },
    hungarian: {
        subject: 'Bejelentkezés megerősítése új eszközről',
        text: (otp: String) => `Üdvözöljük,\n\nÚj eszközről történt bejelentkezési kísérlet az Ön fiókjába.\n\nKérjük, azonosítsa magát az alábbi megerősítő kód megadásával:\n${otp}\n\nEz a kód 15 perc múlva lejár.\n\nHa nem Ön volt, kérjük, azonnal módosítsa jelszavát, és lépjen kapcsolatba ügyfélszolgálatunkkal.\n\nKöszönjük az együttműködését,\nÜgyfélszolgálati csapat`
    },
    indonesian: {
        subject: 'Konfirmasi login dari perangkat baru',
        text: (otp: String) => `Halo,\n\nKami mendeteksi upaya login ke akun Anda dari perangkat baru.\n\nUntuk memastikan bahwa ini benar-benar Anda, silakan masukkan kode verifikasi berikut:\n${otp}\n\nKode ini akan kedaluwarsa dalam 15 menit.\n\nJika ini bukan Anda, segera ubah kata sandi Anda dan hubungi tim dukungan kami.\n\nTerima kasih atas perhatian Anda,\nTim Dukungan`
    },
    italian: {
        subject: 'Conferma di accesso da un nuovo dispositivo',
        text: (otp: String) => `Ciao,\n\nAbbiamo rilevato un tentativo di accesso al tuo account da un nuovo dispositivo.\n\nPer confermare che sei stato tu, inserisci il seguente codice di verifica:\n${otp}\n\nQuesto codice scadrà tra 15 minuti.\n\nSe non sei stato tu, ti consigliamo di cambiare immediatamente la tua password e contattare il nostro team di supporto.\n\nGrazie per la tua attenzione,\nIl team di supporto`
    },
    japanese: {
        subject: '新しい端末からのログイン確認',
        text: (otp: String) => `こんにちは、\n\n新しい端末からあなたのアカウントへのログイン試行が検出されました。\n\nご本人による操作であることを確認するため、以下の確認コードを入力してください：\n${otp}\n\nこのコードの有効期限は15分です。\n\n心当たりがない場合は、すぐにパスワードを変更し、サポートチームまでご連絡ください。\n\nご協力ありがとうございます。\nサポートチーム`
    },
    korean: {
        subject: '새로운 기기에서의 로그인 확인',
        text: (otp: String) => `안녕하세요,\n\n새로운 기기에서 귀하의 계정으로 로그인 시도가 감지되었습니다.\n\n본인 확인을 위해 아래의 인증 코드를 입력해 주세요:\n${otp}\n\n이 코드는 15분 후에 만료됩니다.\n\n본인이 아닌 경우 즉시 비밀번호를 변경하고 고객 지원팀에 연락해 주세요.\n\n감사합니다.\n고객 지원팀`
    },
    lithuanian: {
        subject: 'Prisijungimo patvirtinimas iš naujo įrenginio',
        text: (otp: String) => `Sveiki,\n\nUžfiksavome prisijungimo prie jūsų paskyros bandymą iš naujo įrenginio.\n\nNorėdami patvirtinti, kad tai buvote jūs, įveskite šį patvirtinimo kodą:\n${otp}\n\nŠis kodas nustos galioti po 15 minučių.\n\nJei tai nebuvote jūs, nedelsdami pakeiskite slaptažodį ir susisiekite su mūsų pagalbos komanda.\n\nDėkojame už jūsų budrumą,\nPagalbos komanda`
    },
    malay: {
        subject: 'Pengesahan log masuk dari peranti baharu',
        text: (otp: String) => `Hai,\n\nKami telah mengesan cubaan log masuk ke akaun anda dari peranti baharu.\n\nUntuk mengesahkan bahawa ini adalah anda, sila masukkan kod pengesahan berikut:\n${otp}\n\nKod ini akan tamat tempoh dalam masa 15 minit.\n\nJika ini bukan anda, sila tukar kata laluan anda dengan segera dan hubungi pasukan sokongan kami.\n\nTerima kasih atas keprihatinan anda,\nPasukan Sokongan`
    },
    norwegian: {
        subject: 'Bekreft innlogging fra en ny enhet',
        text: (otp: String) => `Hei,\n\nVi har registrert et innloggingsforsøk på kontoen din fra en ny enhet.\n\nFor å bekrefte at det er deg, vennligst skriv inn følgende verifiseringskode:\n${otp}\n\nDenne koden utløper om 15 minutter.\n\nHvis dette ikke var deg, bør du endre passordet ditt umiddelbart og kontakte vårt kundestøtteteam.\n\nTakk for årvåkenheten din,\nKundestøtteteamet`
    },
    polish: {
        subject: 'Potwierdzenie logowania z nowego urządzenia',
        text: (otp: String) => `Cześć,\n\nWykryliśmy próbę logowania na Twoje konto z nowego urządzenia.\n\nAby potwierdzić, że to Ty, wprowadź poniższy kod weryfikacyjny:\n${otp}\n\nTen kod wygaśnie za 15 minut.\n\nJeśli to nie byłeś Ty, natychmiast zmień hasło i skontaktuj się z naszym zespołem wsparcia.\n\nDziękujemy za czujność,\nZespół wsparcia`
    },
    portuguese: {
        subject: 'Confirmação de login a partir de um novo dispositivo',
        text: (otp: String) => `Olá,\n\nDetectámos uma tentativa de login na sua conta a partir de um novo dispositivo.\n\nPara confirmar que é realmente você, introduza o seguinte código de verificação:\n${otp}\n\nEste código irá expirar dentro de 15 minutos.\n\nSe não foi você, recomendamos que altere a sua palavra-passe imediatamente e contacte a nossa equipa de suporte.\n\nObrigado pela sua atenção,\nA equipa de suporte`
    },
    romanian: {
        subject: 'Confirmare de conectare de pe un dispozitiv nou',
        text: (otp: String) => `Bună,\n\nAm detectat o încercare de conectare la contul dvs. de pe un dispozitiv nou.\n\nPentru a confirma că sunteți dvs., introduceți următorul cod de verificare:\n${otp}\n\nAcest cod va expira în 15 minute.\n\nDacă nu dvs. ați inițiat această acțiune, vă recomandăm să vă schimbați imediat parola și să contactați echipa noastră de suport.\n\nVă mulțumim pentru vigilență,\nEchipa de suport`
    },
    russian: {
        subject: 'Подтверждение входа с нового устройства',
        text: (otp: String) => `Здравствуйте,\n\nМы обнаружили попытку входа в ваш аккаунт с нового устройства.\n\nЧтобы подтвердить, что это были вы, введите следующий код подтверждения:\n${otp}\n\nЭтот код будет действителен в течение 15 минут.\n\nЕсли это были не вы, пожалуйста, немедленно измените пароль и свяжитесь с нашей службой поддержки.\n\nСпасибо за вашу бдительность,\nКоманда поддержки`
    },
    slovak: {
        subject: 'Potvrdenie prihlásenia z nového zariadenia',
        text: (otp: String) => `Dobrý deň,\n\nZaznamenali sme pokus o prihlásenie do vášho účtu z nového zariadenia.\n\nAk chcete potvrdiť, že ste to boli vy, zadajte nasledujúci overovací kód:\n${otp}\n\nTento kód vyprší o 15 minút.\n\nAk ste to neboli vy, odporúčame okamžite zmeniť svoje heslo a kontaktovať náš tím podpory.\n\nĎakujeme za vašu ostražitosť,\nTím podpory`
    },
    slovenian: {
        subject: 'Potrditev prijave z nove naprave',
        text: (otp: String) => `Pozdravljeni,\n\nZaznali smo poskus prijave v vaš račun z nove naprave.\n\nDa potrdite, da ste to res vi, prosimo vnesite naslednjo potrditveno kodo:\n${otp}\n\nTa koda bo potekla čez 15 minut.\n\nČe to niste bili vi, takoj spremenite svoje geslo in se obrnite na našo podporo.\n\nHvala za vašo previdnost,\nEkipa za podporo`
    },
    spanish: {
        subject: 'Confirmación de inicio de sesión desde un nuevo dispositivo',
        text: (otp: String) => `Hola,\n\nHemos detectado un intento de inicio de sesión en su cuenta desde un nuevo dispositivo.\n\nPara confirmar que se trata de usted, introduzca el siguiente código de verificación:\n${otp}\n\nEste código expirará en 15 minutos.\n\nSi no ha sido usted, le recomendamos cambiar su contraseña de inmediato y contactar con nuestro equipo de soporte.\n\nGracias por su atención,\nEl equipo de soporte`
    },
    swedish: {
        subject: 'Bekräftelse av inloggning från en ny enhet',
        text: (otp: String) => `Hej,\n\nVi har upptäckt ett inloggningsförsök på ditt konto från en ny enhet.\n\nFör att bekräfta att det är du, vänligen ange följande verifieringskod:\n${otp}\n\nDenna kod är giltig i 15 minuter.\n\nOm det inte var du, byt lösenord omedelbart och kontakta vårt supportteam.\n\nTack för din vaksamhet,\nSupportteamet`
    },
    thai: {
        subject: 'ยืนยันการเข้าสู่ระบบจากอุปกรณ์ใหม่',
        text: (otp: String) => `สวัสดีค่ะ/ครับ,\n\nเราตรวจพบความพยายามในการเข้าสู่บัญชีของคุณจากอุปกรณ์ใหม่\n\nเพื่อยืนยันว่าเป็นคุณจริง ๆ กรุณากรอกรหัสยืนยันต่อไปนี้:\n${otp}\n\nรหัสนี้จะหมดอายุใน 15 นาที\n\nหากไม่ใช่คุณ กรุณาเปลี่ยนรหัสผ่านทันทีและติดต่อทีมสนับสนุนของเรา\n\nขอบคุณสำหรับความร่วมมือ,\nทีมสนับสนุน`
    },
    turkish: {
        subject: 'Yeni bir cihazdan giriş doğrulaması',
        text: (otp: String) => `Merhaba,\n\nHesabınıza yeni bir cihazdan giriş yapılmaya çalışıldığını tespit ettik.\n\nBu işlemin size ait olduğunu doğrulamak için lütfen aşağıdaki doğrulama kodunu girin:\n${otp}\n\nBu kod 15 dakika içinde geçerliliğini yitirecektir.\n\nEğer bu giriş size ait değilse, lütfen hemen şifrenizi değiştirin ve destek ekibimizle iletişime geçin.\n\nDikkatiniz için teşekkür ederiz,\nDestek Ekibi`
    },
    ukrainian: {
        subject: 'Підтвердження входу з нового пристрою',
        text: (otp: String) => `Вітаємо,\n\nМи зафіксували спробу входу до вашого облікового запису з нового пристрою.\n\nЩоб підтвердити, що це були саме ви, введіть наступний код підтвердження:\n${otp}\n\nЦей код буде дійсний протягом 15 хвилин.\n\nЯкщо це були не ви, негайно змініть свій пароль і зверніться до нашої служби підтримки.\n\nДякуємо за вашу пильність,\nКоманда підтримки`
    },
    vietnamese: {
        subject: 'Xác nhận đăng nhập từ thiết bị mới',
        text: (otp: String) => `Xin chào,\n\nChúng tôi đã phát hiện một nỗ lực đăng nhập vào tài khoản của bạn từ một thiết bị mới.\n\nĐể xác nhận đó là bạn, vui lòng nhập mã xác minh sau:\n${otp}\n\nMã này sẽ hết hạn sau 15 phút.\n\nNếu không phải bạn, vui lòng thay đổi mật khẩu ngay lập tức và liên hệ với nhóm hỗ trợ của chúng tôi.\n\nCảm ơn bạn đã cảnh giác,\nĐội ngũ hỗ trợ`
    },
};