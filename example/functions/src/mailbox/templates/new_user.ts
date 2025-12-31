export const newUserTemplate = {
    arabic: {
        subject: "مرحبًا، حسابك جاهز",
        text: (firstname: string, appName: string, confirmUrl: string) => `مرحبًا${firstname ? ' ' + firstname : ''}\n\nتم إنشاء حسابك${appName ? ' على ' + appName : ''} بنجاح.\n\nلإكمال عملية التسجيل وتأمين حسابك، يرجى تأكيد عنوان بريدك الإلكتروني من خلال النقر على رابط التأكيد أدناه:\n\n${confirmUrl}\n\nبعد تأكيد عنوان بريدك الإلكتروني، ستتمكن من الوصول إلى المنصة والاستفادة الكاملة من جميع الميزات المتاحة.\n\nإذا لم تكن أنت من قام بإنشاء هذا الحساب، يمكنك تجاهل هذا البريد الإلكتروني بأمان.\n\nنراك قريبًا${appName ? ' على ' + appName : ''}،\nفريق${appName ? ' ' + appName : ''}`
    },
    bulgarian: {
        subject: "Добре дошли, вашият акаунт е готов",
        text: (firstname: string, appName: string, confirmUrl: string) => `Здравейте${firstname ? ' ' + firstname : ''},\n\nВашият акаунт${appName ? ' в ' + appName : ''} беше създаден успешно.\n\nЗа да завършите регистрацията си и да защитите акаунта си, моля потвърдете своя имейл адрес, като кликнете върху линка за потвърждение по-долу:\n\n${confirmUrl}\n\nСлед като потвърдите имейл адреса си, ще можете да получите достъп до платформата и да се възползвате пълноценно от всички налични функции.\n\nАко не сте вие лицето, което е създало този акаунт, можете спокойно да игнорирате този имейл.\n\nДо скоро${appName ? ' в ' + appName : ''},\nЕкипът${appName ? ' ' + appName : ''}`
    },
    catalan: {
        subject: "Benvingut/da, el teu compte està llest",
        text: (firstname: string, appName: string, confirmUrl: string) => `Hola${firstname ? ' ' + firstname : ''},\n\nEl teu compte${appName ? ' a ' + appName : ''} s’ha creat correctament.\n\nPer finalitzar el registre i protegir el teu compte, si us plau confirma la teva adreça de correu electrònic fent clic a l’enllaç de confirmació següent:\n\n${confirmUrl}\n\nUn cop confirmada l’adreça de correu electrònic, podràs accedir a la plataforma i gaudir plenament de totes les funcionalitats disponibles.\n\nSi no has estat tu qui ha creat aquest compte, pots ignorar aquest correu electrònic amb total seguretat.\n\nFins aviat${appName ? ' a ' + appName : ''},\nL’equip${appName ? ' ' + appName : ''}`
    },
    chinese: {
        subject: "欢迎，您的账户已准备就绪",
        text: (firstname: string, appName: string, confirmUrl: string) => `您好${firstname ? ' ' + firstname : ''}，\n\n您的账户${appName ? ' 在 ' + appName : ''}已成功创建。\n\n为完成注册并保障您的账户安全，请点击下方的确认链接以验证您的电子邮箱地址：\n\n${confirmUrl}\n\n邮箱地址确认后，您即可访问平台并完整使用所有可用功能。\n\n如果您并未发起此次注册，请放心忽略此邮件。\n\n期待您的使用${appName ? ' 在 ' + appName : ''}，\n${appName ? appName + ' ' : ''}团队`
    },
    croatian: {
        subject: "Dobrodošli, vaš račun je spreman",
        text: (firstname: string, appName: string, confirmUrl: string) => `Pozdrav${firstname ? ' ' + firstname : ''},\n\nVaš račun${appName ? ' na ' + appName : ''} uspješno je kreiran.\n\nKako biste dovršili registraciju i osigurali svoj račun, molimo potvrdite svoju adresu e-pošte klikom na poveznicu za potvrdu u nastavku:\n\n${confirmUrl}\n\nNakon potvrde adrese e-pošte moći ćete pristupiti platformi i u potpunosti koristiti sve dostupne funkcionalnosti.\n\nAko niste vi pokrenuli ovu registraciju, možete bezbrižno ignorirati ovu e-poruku.\n\nVidimo se uskoro${appName ? ' na ' + appName : ''},\nTim${appName ? ' ' + appName : ''}`
    },
    czech: {
        subject: "Vítejte, váš účet je připraven",
        text: (firstname: string, appName: string, confirmUrl: string) => `Dobrý den${firstname ? ' ' + firstname : ''},\n\nVáš účet${appName ? ' v ' + appName : ''} byl úspěšně vytvořen.\n\nPro dokončení registrace a zabezpečení vašeho účtu prosím potvrďte svou e-mailovou adresu kliknutím na potvrzovací odkaz níže:\n\n${confirmUrl}\n\nPo potvrzení e-mailové adresy budete mít přístup k platformě a budete moci plně využívat všechny dostupné funkce.\n\nPokud jste tento účet nezaložili vy, můžete tento e-mail bez obav ignorovat.\n\nBrzy na viděnou${appName ? ' v ' + appName : ''},\nTým${appName ? ' ' + appName : ''}`
    },
    danish: {
        subject: "Velkommen, din konto er klar",
        text: (firstname: string, appName: string, confirmUrl: string) => `Hej${firstname ? ' ' + firstname : ''},\n\nDin konto${appName ? ' på ' + appName : ''} er blevet oprettet.\n\nFor at færdiggøre din tilmelding og sikre din konto bedes du bekræfte din e-mailadresse ved at klikke på bekræftelseslinket nedenfor:\n\n${confirmUrl}\n\nNår din e-mailadresse er bekræftet, får du adgang til platformen og kan benytte alle tilgængelige funktioner fuldt ud.\n\nHvis du ikke selv har oprettet denne konto, kan du trygt ignorere denne e-mail.\n\nVi ses snart${appName ? ' på ' + appName : ''},\nTeamet${appName ? ' ' + appName : ''}`
    },
    dutch: {
        subject: "Welkom, je account is klaar",
        text: (firstname: string, appName: string, confirmUrl: string) => `Hallo${firstname ? ' ' + firstname : ''},\n\nJe account${appName ? ' bij ' + appName : ''} is succesvol aangemaakt.\n\nOm je registratie te voltooien en je account te beveiligen, verzoeken wij je je e-mailadres te bevestigen door op de bevestigingslink hieronder te klikken:\n\n${confirmUrl}\n\nNa bevestiging van je e-mailadres krijg je toegang tot het platform en kun je volledig gebruikmaken van alle beschikbare functies.\n\nAls jij deze registratie niet hebt uitgevoerd, kun je deze e-mail gerust negeren.\n\nTot snel${appName ? ' bij ' + appName : ''},\nHet team${appName ? ' ' + appName : ''}`
    },
    english: {
        subject: "Welcome, your account is ready",
        text: (firstname: string, appName: string, confirmUrl: string) => `Hello${firstname ? ' ' + firstname : ''},\n\nYour account${appName ? ' on ' + appName : ''} has been successfully created.\n\nTo complete your registration and secure your account, please confirm your email address by clicking the confirmation link below:\n\n${confirmUrl}\n\nOnce your email address is confirmed, you will be able to access the platform and fully enjoy all available features.\n\nIf you did not initiate this registration, you can safely ignore this email.\n\nSee you soon${appName ? ' on ' + appName : ''},\nThe${appName ? ' ' + appName : ''} Team`
    },
    finnish: {
        subject: "Tervetuloa, tilisi on valmis",
        text: (firstname: string, appName: string, confirmUrl: string) => `Hei${firstname ? ' ' + firstname : ''},\n\nTilisi${appName ? ' palvelussa ' + appName : ''} on luotu onnistuneesti.\n\nViimeistelläksesi rekisteröitymisesi ja suojataksesi tilisi, vahvista sähköpostiosoitteesi klikkaamalla alla olevaa vahvistuslinkkiä:\n\n${confirmUrl}\n\nKun sähköpostiosoitteesi on vahvistettu, pääset käyttämään alustaa ja kaikkia saatavilla olevia ominaisuuksia.\n\nJos et ole itse luonut tätä tiliä, voit huoletta ohittaa tämän sähköpostin.\n\nNähdään pian${appName ? ' palvelussa ' + appName : ''},\nTiimi${appName ? ' ' + appName : ''}`
    },
    french: {
        subject: "Bienvenue, votre compte est prêt",
        text: (firstname: string, appName: string, confirmUrl: string) => `Bonjour${firstname ? ' ' + firstname : ''},\n\nVotre compte${appName ? ' sur ' + appName : ''} a bien été créé.\n\nAfin de finaliser votre inscription et de sécuriser votre compte, merci de confirmer votre adresse e-mail en cliquant sur le lien de confirmation ci-dessous :\n\n${confirmUrl}\n\nUne fois votre adresse e-mail confirmée, vous pourrez accéder à la plateforme et profiter pleinement de l’ensemble des fonctionnalités disponibles.\n\nSi vous n’êtes pas à l’origine de cette inscription, vous pouvez ignorer cet e-mail en toute sécurité.\n\nÀ très bientôt${appName ? ' sur ' + appName : ''},\nL’équipe${appName ? ' ' + appName : ''}`
    },
    german: {
        subject: "Willkommen, Ihr Konto ist bereit",
        text: (firstname: string, appName: string, confirmUrl: string) => `Hallo${firstname ? ' ' + firstname : ''},\n\nIhr Konto${appName ? ' bei ' + appName : ''} wurde erfolgreich erstellt.\n\nUm Ihre Registrierung abzuschließen und Ihr Konto zu sichern, bestätigen Sie bitte Ihre E-Mail-Adresse, indem Sie auf den untenstehenden Bestätigungslink klicken:\n\n${confirmUrl}\n\nNach der Bestätigung Ihrer E-Mail-Adresse können Sie auf die Plattform zugreifen und alle verfügbaren Funktionen vollständig nutzen.\n\nWenn Sie diese Registrierung nicht selbst durchgeführt haben, können Sie diese E-Mail bedenkenlos ignorieren.\n\nBis bald${appName ? ' bei ' + appName : ''},\nDas${appName ? ' ' + appName : ''} Team`
    },
    greek: {
        subject: "Καλώς ήρθατε, ο λογαριασμός σας είναι έτοιμος",
        text: (firstname: string, appName: string, confirmUrl: string) => `Γεια σας${firstname ? ' ' + firstname : ''},\n\nΟ λογαριασμός σας${appName ? ' στο ' + appName : ''} δημιουργήθηκε με επιτυχία.\n\nΓια να ολοκληρώσετε την εγγραφή σας και να ασφαλίσετε τον λογαριασμό σας, παρακαλούμε επιβεβαιώστε τη διεύθυνση ηλεκτρονικού ταχυδρομείου σας κάνοντας κλικ στον παρακάτω σύνδεσμο επιβεβαίωσης:\n\n${confirmUrl}\n\nΜόλις επιβεβαιωθεί η διεύθυνση ηλεκτρονικού ταχυδρομείου σας, θα μπορείτε να αποκτήσετε πρόσβαση στην πλατφόρμα και να χρησιμοποιήσετε πλήρως όλες τις διαθέσιμες λειτουργίες.\n\nΕάν δεν ξεκινήσατε εσείς αυτήν την εγγραφή, μπορείτε να αγνοήσετε με ασφάλεια αυτό το email.\n\nΤα λέμε σύντομα${appName ? ' στο ' + appName : ''},\nΗ${appName ? ' ' + appName : ''} Ομάδα`
    },
    hebrew: {
        subject: "ברוכים הבאים, החשבון שלך מוכן",
        text: (firstname: string, appName: string, confirmUrl: string) => `שלום${firstname ? ' ' + firstname : ''},\n\nהחשבון שלך${appName ? ' ב־' + appName : ''} נוצר בהצלחה.\n\nכדי להשלים את ההרשמה ולאבטח את החשבון שלך, אנא אשר/י את כתובת הדוא״ל שלך על ידי לחיצה על קישור האישור למטה:\n\n${confirmUrl}\n\nלאחר אישור כתובת הדוא״ל, תוכל/י לגשת לפלטפורמה ולהשתמש בכל הפונקציות הזמינות במלואן.\n\nאם לא את/ה יזמת את ההרשמה הזו, ניתן להתעלם מהודעה זו בבטחה.\n\nנתראה בקרוב${appName ? ' ב־' + appName : ''},\nצוות${appName ? ' ' + appName : ''}`
    },
    hindi: {
        subject: "स्वागत है, आपका खाता तैयार है",
        text: (firstname: string, appName: string, confirmUrl: string) => `नमस्ते${firstname ? ' ' + firstname : ''},\n\nआपका खाता${appName ? ' ' + appName + ' पर' : ''} सफलतापूर्वक बना दिया गया है।\n\nअपना पंजीकरण पूरा करने और अपने खाते को सुरक्षित रखने के लिए, कृपया नीचे दिए गए पुष्टि लिंक पर क्लिक करके अपने ईमेल पते की पुष्टि करें:\n\n${confirmUrl}\n\nएक बार आपका ईमेल पता पुष्टि हो जाने के बाद, आप प्लेटफ़ॉर्म तक पहुँच सकेंगे और उपलब्ध सभी सुविधाओं का पूर्ण रूप से उपयोग कर सकेंगे।\n\nयदि आपने यह पंजीकरण स्वयं नहीं किया है, तो आप इस ईमेल को सुरक्षित रूप से अनदेखा कर सकते हैं।\n\nजल्द ही मिलेंगे${appName ? ' ' + appName + ' पर' : ''},\n${appName ? appName + ' ' : ''}टीम`
    },
    hungarian: {
        subject: "Üdvözöljük, fiókja készen áll",
        text: (firstname: string, appName: string, confirmUrl: string) => `Üdvözöljük${firstname ? ' ' + firstname : ''},\n\nFiókja${appName ? ' a(z) ' + appName + ' oldalon' : ''} sikeresen létrejött.\n\nA regisztráció befejezéséhez és fiókja biztonságának érdekében kérjük, erősítse meg e-mail-címét az alábbi megerősítő linkre kattintva:\n\n${confirmUrl}\n\nAz e-mail-cím megerősítése után hozzáférhet a platformhoz, és teljes mértékben kihasználhatja az összes elérhető funkciót.\n\nHa nem Ön hozta létre ezt a fiókot, nyugodtan figyelmen kívül hagyhatja ezt az e-mailt.\n\nHamarosan találkozunk${appName ? ' a(z) ' + appName + ' oldalon' : ''},\nA${appName ? ' ' + appName : ''} csapat`
    },
    indonesian: {
        subject: "Selamat datang, akun Anda sudah siap",
        text: (firstname: string, appName: string, confirmUrl: string) => `Halo${firstname ? ' ' + firstname : ''},\n\nAkun Anda${appName ? ' di ' + appName : ''} telah berhasil dibuat.\n\nUntuk menyelesaikan pendaftaran dan mengamankan akun Anda, silakan konfirmasi alamat email Anda dengan mengklik tautan konfirmasi di bawah ini:\n\n${confirmUrl}\n\nSetelah alamat email Anda dikonfirmasi, Anda dapat mengakses platform dan menikmati seluruh fitur yang tersedia.\n\nJika Anda tidak melakukan pendaftaran ini, Anda dapat mengabaikan email ini dengan aman.\n\nSampai jumpa${appName ? ' di ' + appName : ''},\nTim${appName ? ' ' + appName : ''}`
    },
    italian: {
        subject: "Benvenuto, il tuo account è pronto",
        text: (firstname: string, appName: string, confirmUrl: string) => `Ciao${firstname ? ' ' + firstname : ''},\n\nIl tuo account${appName ? ' su ' + appName : ''} è stato creato con successo.\n\nPer completare la registrazione e proteggere il tuo account, ti invitiamo a confermare il tuo indirizzo email cliccando sul link di conferma qui sotto:\n\n${confirmUrl}\n\nUna volta confermato l’indirizzo email, potrai accedere alla piattaforma e usufruire pienamente di tutte le funzionalità disponibili.\n\nSe non sei stato tu a creare questo account, puoi ignorare questa email in tutta sicurezza.\n\nA presto${appName ? ' su ' + appName : ''},\nIl team${appName ? ' ' + appName : ''}`
    },
    japanese: {
        subject: "ようこそ、アカウントの準備ができました",
        text: (firstname: string, appName: string, confirmUrl: string) => `こんにちは${firstname ? ' ' + firstname : ''}、\n\n${appName ? appName + ' の' : ''}アカウントが正常に作成されました。\n\n登録を完了し、アカウントを安全に保つため、以下の確認リンクをクリックしてメールアドレスを確認してください。\n\n${confirmUrl}\n\nメールアドレスの確認が完了すると、プラットフォームにアクセスし、すべての機能をご利用いただけます。\n\nこの登録に心当たりがない場合は、このメールを無視しても問題ありません。\n\nそれではまた${appName ? ' ' + appName + 'で' : ''}、\n${appName ? appName + ' ' : ''}チーム`
    },
    korean: {
        subject: "환영합니다, 계정이 준비되었습니다",
        text: (firstname: string, appName: string, confirmUrl: string) => `안녕하세요${firstname ? ' ' + firstname : ''},\n\n귀하의 계정${appName ? ' (' + appName + ')' : ''}이(가) 성공적으로 생성되었습니다.\n\n가입을 완료하고 계정을 안전하게 보호하기 위해 아래의 확인 링크를 클릭하여 이메일 주소를 확인해 주세요:\n\n${confirmUrl}\n\n이메일 주소가 확인되면 플랫폼에 접속하여 모든 기능을 완전히 이용하실 수 있습니다.\n\n본인이 이 계정을 생성하지 않았다면, 이 이메일을 안전하게 무시하셔도 됩니다.\n\n곧 다시 뵙겠습니다${appName ? ' (' + appName + ')' : ''},\n${appName ? appName + ' ' : ''}팀`
    },
    lithuanian: {
        subject: "Sveiki atvykę, jūsų paskyra paruošta",
        text: (firstname: string, appName: string, confirmUrl: string) => `Sveiki${firstname ? ' ' + firstname : ''},\n\nJūsų paskyra${appName ? ' „' + appName + '“' : ''} sėkmingai sukurta.\n\nNorėdami užbaigti registraciją ir apsaugoti savo paskyrą, patvirtinkite savo el. pašto adresą spustelėdami žemiau pateiktą patvirtinimo nuorodą:\n\n${confirmUrl}\n\nPatvirtinus el. pašto adresą, galėsite prisijungti prie platformos ir visapusiškai naudotis visomis galimomis funkcijomis.\n\nJei šios paskyros nekūrėte jūs, galite saugiai ignoruoti šį el. laišką.\n\nIki pasimatymo${appName ? ' „' + appName + '“' : ''},\nKomanda${appName ? ' ' + appName : ''}`
    },
    malay: {
        subject: "Selamat datang, akaun anda sudah sedia",
        text: (firstname: string, appName: string, confirmUrl: string) => `Hai${firstname ? ' ' + firstname : ''},\n\nAkaun anda${appName ? ' di ' + appName : ''} telah berjaya dicipta.\n\nUntuk melengkapkan pendaftaran dan melindungi akaun anda, sila sahkan alamat e-mel anda dengan mengklik pautan pengesahan di bawah:\n\n${confirmUrl}\n\nSetelah alamat e-mel anda disahkan, anda boleh mengakses platform dan menikmati sepenuhnya semua ciri yang tersedia.\n\nJika anda tidak memulakan pendaftaran ini, anda boleh mengabaikan e-mel ini dengan selamat.\n\nJumpa lagi${appName ? ' di ' + appName : ''},\nPasukan${appName ? ' ' + appName : ''}`
    },
    norwegian: {
        subject: "Velkommen, kontoen din er klar",
        text: (firstname: string, appName: string, confirmUrl: string) => `Hei${firstname ? ' ' + firstname : ''},\n\nKontoen din${appName ? ' hos ' + appName : ''} er opprettet.\n\nFor å fullføre registreringen og sikre kontoen din, vennligst bekreft e-postadressen din ved å klikke på bekreftelseslenken nedenfor:\n\n${confirmUrl}\n\nNår e-postadressen din er bekreftet, får du tilgang til plattformen og kan bruke alle tilgjengelige funksjoner fullt ut.\n\nHvis du ikke selv har opprettet denne kontoen, kan du trygt ignorere denne e-posten.\n\nVi sees snart${appName ? ' hos ' + appName : ''},\nTeamet${appName ? ' ' + appName : ''}`
    },
    polish: {
        subject: "Witamy, Twoje konto jest gotowe",
        text: (firstname: string, appName: string, confirmUrl: string) => `Witaj${firstname ? ' ' + firstname : ''},\n\nTwoje konto${appName ? ' w ' + appName : ''} zostało pomyślnie utworzone.\n\nAby dokończyć rejestrację i zabezpieczyć swoje konto, potwierdź swój adres e-mail, klikając poniższy link potwierdzający:\n\n${confirmUrl}\n\nPo potwierdzeniu adresu e-mail uzyskasz dostęp do platformy i będziesz mógł w pełni korzystać ze wszystkich dostępnych funkcji.\n\nJeśli to nie Ty utworzyłeś to konto, możesz bezpiecznie zignorować tę wiadomość e-mail.\n\nDo zobaczenia wkrótce${appName ? ' w ' + appName : ''},\nZespół${appName ? ' ' + appName : ''}`
    },
    portuguese: {
        subject: "Bem-vindo, a sua conta está pronta",
        text: (firstname: string, appName: string, confirmUrl: string) => `Olá${firstname ? ' ' + firstname : ''},\n\nA sua conta${appName ? ' na ' + appName : ''} foi criada com sucesso.\n\nPara concluir o registo e proteger a sua conta, confirme o seu endereço de e-mail clicando no link de confirmação abaixo:\n\n${confirmUrl}\n\nDepois de confirmar o seu endereço de e-mail, poderá aceder à plataforma e usufruir plenamente de todas as funcionalidades disponíveis.\n\nSe não foi você quem criou esta conta, pode ignorar este e-mail com toda a segurança.\n\nAté breve${appName ? ' na ' + appName : ''},\nA equipa${appName ? ' ' + appName : ''}`
    },
    romanian: {
        subject: "Bun venit, contul tău este gata",
        text: (firstname: string, appName: string, confirmUrl: string) => `Salut${firstname ? ' ' + firstname : ''},\n\nContul tău${appName ? ' pe ' + appName : ''} a fost creat cu succes.\n\nPentru a finaliza înregistrarea și a-ți securiza contul, te rugăm să confirmi adresa ta de e-mail făcând clic pe linkul de confirmare de mai jos:\n\n${confirmUrl}\n\nDupă confirmarea adresei de e-mail, vei putea accesa platforma și te vei putea bucura pe deplin de toate funcționalitățile disponibile.\n\nDacă nu tu ai inițiat această înregistrare, poți ignora acest e-mail în siguranță.\n\nPe curând${appName ? ' pe ' + appName : ''},\nEchipa${appName ? ' ' + appName : ''}`
    },
    russian: {
        subject: "Добро пожаловать, ваш аккаунт готов",
        text: (firstname: string, appName: string, confirmUrl: string) => `Здравствуйте${firstname ? ' ' + firstname : ''},\n\nВаш аккаунт${appName ? ' в ' + appName : ''} был успешно создан.\n\nЧтобы завершить регистрацию и обеспечить безопасность вашего аккаунта, пожалуйста, подтвердите ваш адрес электронной почты, перейдя по ссылке ниже:\n\n${confirmUrl}\n\nПосле подтверждения адреса электронной почты вы сможете получить доступ к платформе и в полной мере воспользоваться всеми доступными функциями.\n\nЕсли вы не инициировали эту регистрацию, вы можете спокойно проигнорировать это письмо.\n\nДо скорой встречи${appName ? ' в ' + appName : ''},\nКоманда${appName ? ' ' + appName : ''}`
    },
    slovak: {
        subject: "Vitajte, váš účet je pripravený",
        text: (firstname: string, appName: string, confirmUrl: string) => `Dobrý deň${firstname ? ' ' + firstname : ''},\n\nVáš účet${appName ? ' v ' + appName : ''} bol úspešne vytvorený.\n\nNa dokončenie registrácie a zabezpečenie vášho účtu prosím potvrďte svoju e-mailovú adresu kliknutím na potvrdzovací odkaz nižšie:\n\n${confirmUrl}\n\nPo potvrdení e-mailovej adresy budete mať prístup k platforme a budete môcť naplno využívať všetky dostupné funkcie.\n\nAk ste tento účet nevytvorili vy, môžete tento e-mail bez obáv ignorovať.\n\nTešíme sa na vás${appName ? ' v ' + appName : ''},\nTím${appName ? ' ' + appName : ''}`
    },
    slovenian: {
        subject: "Dobrodošli, vaš račun je pripravljen",
        text: (firstname: string, appName: string, confirmUrl: string) => `Pozdravljeni${firstname ? ' ' + firstname : ''},\n\nVaš račun${appName ? ' na ' + appName : ''} je bil uspešno ustvarjen.\n\nZa dokončanje registracije in zaščito vašega računa prosimo potrdite svoj e-poštni naslov s klikom na spodnjo potrditveno povezavo:\n\n${confirmUrl}\n\nPo potrditvi e-poštnega naslova boste lahko dostopali do platforme in v celoti uporabljali vse razpoložljive funkcionalnosti.\n\nČe tega računa niste ustvarili vi, lahko to e-poštno sporočilo varno prezrete.\n\nSe vidimo kmalu${appName ? ' na ' + appName : ''},\nEkipa${appName ? ' ' + appName : ''}`
    },
    spanish: {
        subject: "Bienvenido, tu cuenta está lista",
        text: (firstname: string, appName: string, confirmUrl: string) => `Hola${firstname ? ' ' + firstname : ''},\n\nTu cuenta${appName ? ' en ' + appName : ''} ha sido creada correctamente.\n\nPara completar el registro y proteger tu cuenta, confirma tu dirección de correo electrónico haciendo clic en el enlace de confirmación que aparece a continuación:\n\n${confirmUrl}\n\nUna vez confirmada tu dirección de correo electrónico, podrás acceder a la plataforma y disfrutar plenamente de todas las funcionalidades disponibles.\n\nSi no has iniciado este registro, puedes ignorar este correo electrónico con total seguridad.\n\nHasta pronto${appName ? ' en ' + appName : ''},\nEl equipo${appName ? ' ' + appName : ''}`
    },
    swedish: {
        subject: "Välkommen, ditt konto är klart",
        text: (firstname: string, appName: string, confirmUrl: string) => `Hej${firstname ? ' ' + firstname : ''},\n\nDitt konto${appName ? ' hos ' + appName : ''} har skapats framgångsrikt.\n\nFör att slutföra registreringen och säkra ditt konto, vänligen bekräfta din e-postadress genom att klicka på bekräftelselänken nedan:\n\n${confirmUrl}\n\nNär din e-postadress har bekräftats får du tillgång till plattformen och kan använda alla tillgängliga funktioner fullt ut.\n\nOm du inte själv har skapat detta konto kan du tryggt ignorera detta e-postmeddelande.\n\nVi ses snart${appName ? ' hos ' + appName : ''},\nTeamet${appName ? ' ' + appName : ''}`
    },
    thai: {
        subject: "ยินดีต้อนรับ บัญชีของคุณพร้อมใช้งานแล้ว",
        text: (firstname: string, appName: string, confirmUrl: string) => `สวัสดี${firstname ? ' ' + firstname : ''},\n\nบัญชีของคุณ${appName ? ' บน ' + appName : ''}ถูกสร้างเรียบร้อยแล้ว\n\nเพื่อดำเนินการลงทะเบียนให้เสร็จสมบูรณ์และรักษาความปลอดภัยให้กับบัญชีของคุณ กรุณายืนยันที่อยู่อีเมลของคุณโดยคลิกลิงก์ยืนยันด้านล่าง:\n\n${confirmUrl}\n\nเมื่อยืนยันที่อยู่อีเมลเรียบร้อยแล้ว คุณจะสามารถเข้าถึงแพลตฟอร์มและใช้งานฟีเจอร์ต่าง ๆ ได้อย่างครบถ้วน\n\nหากคุณไม่ได้เป็นผู้ทำการสมัครนี้ คุณสามารถละเว้นอีเมลฉบับนี้ได้อย่างปลอดภัย\n\nแล้วพบกันเร็ว ๆ นี้${appName ? ' บน ' + appName : ''},\nทีมงาน${appName ? ' ' + appName : ''}`
    },
    turkish: {
        subject: "Hoş geldiniz, hesabınız hazır",
        text: (firstname: string, appName: string, confirmUrl: string) => `Merhaba${firstname ? ' ' + firstname : ''},\n\nHesabınız${appName ? ' ' + appName + ' üzerinde' : ''} başarıyla oluşturuldu.\n\nKaydınızı tamamlamak ve hesabınızı güvence altına almak için lütfen aşağıdaki onay bağlantısına tıklayarak e-posta adresinizi doğrulayın:\n\n${confirmUrl}\n\nE-posta adresiniz doğrulandıktan sonra platforma erişebilir ve tüm mevcut özelliklerden eksiksiz şekilde yararlanabilirsiniz.\n\nBu kaydı siz başlatmadıysanız, bu e-postayı güvenle yok sayabilirsiniz.\n\nYakında görüşmek üzere${appName ? ' ' + appName + ' üzerinde' : ''},\n${appName ? appName + ' ' : ''}Ekibi`
    },
    ukrainian: {
        subject: "Ласкаво просимо, ваш обліковий запис готовий",
        text: (firstname: string, appName: string, confirmUrl: string) => `Вітаємо${firstname ? ' ' + firstname : ''},\n\nВаш обліковий запис${appName ? ' у ' + appName : ''} було успішно створено.\n\nЩоб завершити реєстрацію та захистити свій обліковий запис, будь ласка, підтвердьте свою адресу електронної пошти, натиснувши на посилання підтвердження нижче:\n\n${confirmUrl}\n\nПісля підтвердження адреси електронної пошти ви зможете отримати доступ до платформи та повноцінно користуватися всіма доступними функціями.\n\nЯкщо ви не ініціювали цю реєстрацію, ви можете безпечно проігнорувати цей лист.\n\nДо зустрічі${appName ? ' у ' + appName : ''},\nКоманда${appName ? ' ' + appName : ''}`
    },
    vietnamese: {
        subject: "Chào mừng, tài khoản của bạn đã sẵn sàng",
        text: (firstname: string, appName: string, confirmUrl: string) => `Xin chào${firstname ? ' ' + firstname : ''},\n\nTài khoản của bạn${appName ? ' trên ' + appName : ''} đã được tạo thành công.\n\nĐể hoàn tất đăng ký và bảo mật tài khoản của bạn, vui lòng xác nhận địa chỉ email của bạn bằng cách nhấp vào liên kết xác nhận bên dưới:\n\n${confirmUrl}\n\nSau khi địa chỉ email được xác nhận, bạn sẽ có thể truy cập nền tảng và sử dụng đầy đủ tất cả các tính năng hiện có.\n\nNếu bạn không thực hiện việc đăng ký này, bạn có thể bỏ qua email này một cách an toàn.\n\nHẹn gặp lại${appName ? ' trên ' + appName : ''},\nĐội ngũ${appName ? ' ' + appName : ''}`
    },
};