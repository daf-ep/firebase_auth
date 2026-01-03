export const resetPasswordTemplate = {
    arabic: {
        subject: 'إعادة تعيين كلمة المرور',
        text: (resetLink: string) => `مرحبًا،\n\nلقد تم طلب إعادة تعيين كلمة المرور الخاصة بحسابك.\n\nللمتابعة وتعيين كلمة مرور جديدة، يرجى النقر على الرابط الآمن أدناه:\n\n${resetLink}\n\nهذا الرابط شخصي وصالح لمدة 15 دقيقة فقط.\n\nإذا لم تكن أنت من قام بهذا الطلب، فلا يلزمك اتخاذ أي إجراء. سيظل حسابك آمنًا دون أي تغيير.\n\nمع أطيب التحيات،\nفريق الدعم`
    },
    bulgarian: {
        subject: 'Възстановяване на паролата',
        text: (resetLink: string) => `Здравейте,\n\nБеше подадена заявка за възстановяване на паролата на вашия акаунт.\n\nЗа да продължите и зададете нова парола, моля кликнете върху защитения линк по-долу:\n\n${resetLink}\n\nТози линк е личен и валиден за 15 минути.\n\nАко не сте направили тази заявка, не е необходимо да предприемате никакви действия. Вашият акаунт ще остане защитен без промени.\n\nС уважение,\nЕкипът по поддръжка`
    },
    catalan: {
        subject: 'Restabliment de la contrasenya',
        text: (resetLink: string) => `Hola,\n\nS’ha sol·licitat el restabliment de la contrasenya del teu compte.\n\nPer continuar i establir una nova contrasenya, fes clic a l’enllaç segur següent:\n\n${resetLink}\n\nAquest enllaç és personal i és vàlid durant 15 minuts.\n\nSi no has fet aquesta sol·licitud, no cal que facis cap acció. El teu compte romandrà segur sense cap canvi.\n\nAtentament,\nL’equip de suport`
    },
    chinese: {
        subject: '重置您的密码',
        text: (resetLink: string) => `您好，\n\n我们已收到您关于重置账户密码的请求。\n\n请点击下方的安全链接以继续并设置新的密码：\n\n${resetLink}\n\n该链接为个人专用，有效期为 15 分钟。\n\n如果您并未发起此请求，请忽略此邮件。您的账户将保持安全，不会发生任何更改。\n\n此致敬礼，\n支持团队`
    },
    croatian: {
        subject: 'Poništavanje lozinke',
        text: (resetLink: string) => `Pozdrav,\n\nZaprimljen je zahtjev za poništavanje lozinke vašeg računa.\n\nKako biste nastavili i postavili novu lozinku, molimo kliknite na sigurnu poveznicu u nastavku:\n\n${resetLink}\n\nOva poveznica je osobna i vrijedi 15 minuta.\n\nAko niste vi poslali ovaj zahtjev, nije potrebno poduzimati nikakve radnje. Vaš račun ostat će siguran bez ikakvih promjena.\n\nSrdačan pozdrav,\nTim za podršku`
    },
    czech: {
        subject: 'Obnovení hesla',
        text: (resetLink: string) => `Dobrý den,\n\nByla podána žádost o obnovení hesla k vašemu účtu.\n\nPro pokračování a nastavení nového hesla klikněte prosím na zabezpečený odkaz níže:\n\n${resetLink}\n\nTento odkaz je osobní a platný po dobu 15 minut.\n\nPokud jste tuto žádost nepodali vy, není nutné podnikat žádné kroky. Váš účet zůstane zabezpečen beze změn.\n\nS pozdravem,\nTým podpory`
    },
    danish: {
        subject: 'Nulstilling af adgangskode',
        text: (resetLink: string) => `Hej,\n\nDer er blevet anmodet om nulstilling af adgangskoden til din konto.\n\nFor at fortsætte og angive en ny adgangskode, bedes du klikke på det sikre link nedenfor:\n\n${resetLink}\n\nDette link er personligt og gyldigt i 15 minutter.\n\nHvis du ikke har anmodet om denne nulstilling, behøver du ikke foretage dig noget. Din konto forbliver sikker uden ændringer.\n\nVenlig hilsen,\nSupportteamet`
    },
    dutch: {
        subject: 'Wachtwoord opnieuw instellen',
        text: (resetLink: string) => `Hallo,\n\nEr is een verzoek gedaan om het wachtwoord van je account opnieuw in te stellen.\n\nOm door te gaan en een nieuw wachtwoord in te stellen, klik op de beveiligde link hieronder:\n\n${resetLink}\n\nDeze link is persoonlijk en 15 minuten geldig.\n\nAls je deze aanvraag niet hebt gedaan, hoef je geen actie te ondernemen. Je account blijft veilig en er worden geen wijzigingen aangebracht.\n\nMet vriendelijke groet,\nHet supportteam`
    },
    english: {
        subject: 'Reset your password',
        text: (resetLink: string) => `Hello,\n\nA request has been made to reset the password for your account.\n\nTo continue and set a new password, please click the secure link below:\n\n${resetLink}\n\nThis link is personal and valid for 15 minutes.\n\nIf you did not request this reset, no action is required. Your account will remain secure and unchanged.\n\nBest regards,\nThe Support Team`
    },
    finnish: {
        subject: 'Salasanan palauttaminen',
        text: (resetLink: string) => `Hei,\n\nTilillesi on pyydetty salasanan palauttamista.\n\nJatkaaksesi ja asettaaksesi uuden salasanan, klikkaa alla olevaa suojattua linkkiä:\n\n${resetLink}\n\nTämä linkki on henkilökohtainen ja voimassa 15 minuuttia.\n\nJos et ole tehnyt tätä pyyntöä, sinun ei tarvitse tehdä mitään. Tilisi pysyy turvallisena ilman muutoksia.\n\nYstävällisin terveisin,\nTukitiimi`
    },
    french: {
        subject: 'Réinitialisation de votre mot de passe',
        text: (resetLink: string) => `Bonjour,\n\nUne demande de réinitialisation de mot de passe a été effectuée pour votre compte.\n\nPour continuer et définir un nouveau mot de passe, veuillez cliquer sur le lien sécurisé ci-dessous :\n\n${resetLink}\n\nCe lien est personnel et valable pendant 15 minutes.\n\nSi vous n’êtes pas à l’origine de cette demande, aucune action n’est requise. Votre compte restera sécurisé sans modification.\n\nCordialement,\nL’équipe support`
    },
    german: {
        subject: 'Passwort zurücksetzen',
        text: (resetLink: string) => `Hallo,\n\nEs wurde eine Anfrage zum Zurücksetzen des Passworts für Ihr Konto gestellt.\n\nUm fortzufahren und ein neues Passwort festzulegen, klicken Sie bitte auf den sicheren Link unten:\n\n${resetLink}\n\nDieser Link ist persönlich und 15 Minuten gültig.\n\nWenn Sie diese Anfrage nicht gestellt haben, ist keine Aktion erforderlich. Ihr Konto bleibt sicher und unverändert.\n\nMit freundlichen Grüßen,\nDas Support-Team`
    },
    greek: {
        subject: 'Επαναφορά κωδικού πρόσβασης',
        text: (resetLink: string) => `Γεια σας,\n\nΥποβλήθηκε αίτημα για την επαναφορά του κωδικού πρόσβασης του λογαριασμού σας.\n\nΓια να συνεχίσετε και να ορίσετε νέο κωδικό πρόσβασης, παρακαλούμε κάντε κλικ στον ασφαλή σύνδεσμο παρακάτω:\n\n${resetLink}\n\nΑυτός ο σύνδεσμος είναι προσωπικός και ισχύει για 15 λεπτά.\n\nΕάν δεν υποβάλατε εσείς αυτό το αίτημα, δεν απαιτείται καμία ενέργεια. Ο λογαριασμός σας θα παραμείνει ασφαλής χωρίς αλλαγές.\n\nΜε εκτίμηση,\nΗ ομάδα υποστήριξης`
    },
    hebrew: {
        subject: 'איפוס סיסמה',
        text: (resetLink: string) => `שלום,\n\nהתקבלה בקשה לאיפוס סיסמת החשבון שלך.\n\nכדי להמשיך ולהגדיר סיסמה חדשה, אנא לחץ על הקישור המאובטח שלהלן:\n\n${resetLink}\n\nקישור זה הוא אישי ותקף למשך 15 דקות.\n\nאם לא אתה ביצעת בקשה זו, אין צורך לבצע כל פעולה. חשבונך יישאר מאובטח ללא שינוי.\n\nבברכה,\nצוות התמיכה`
    },
    hindi: {
        subject: 'अपना पासवर्ड रीसेट करें',
        text: (resetLink: string) => `नमस्ते,\n\nआपके खाते के लिए पासवर्ड रीसेट करने का अनुरोध किया गया है।\n\nआगे बढ़ने और नया पासवर्ड सेट करने के लिए, कृपया नीचे दिए गए सुरक्षित लिंक पर क्लिक करें:\n\n${resetLink}\n\nयह लिंक व्यक्तिगत है और 15 मिनट के लिए मान्य है।\n\nयदि आपने यह अनुरोध नहीं किया है, तो किसी भी कार्रवाई की आवश्यकता नहीं है। आपका खाता सुरक्षित रहेगा और इसमें कोई परिवर्तन नहीं किया जाएगा।\n\nसादर,\nसपोर्ट टीम`
    },
    hungarian: {
        subject: 'Jelszó visszaállítása',
        text: (resetLink: string) => `Üdvözöljük,\n\nKérés érkezett a fiókja jelszavának visszaállítására.\n\nA folytatáshoz és új jelszó beállításához kérjük, kattintson az alábbi biztonságos linkre:\n\n${resetLink}\n\nEz a link személyre szóló és 15 percig érvényes.\n\nHa nem Ön kezdeményezte ezt a kérést, nincs szükség semmilyen teendőre. Fiókja biztonságban marad változtatás nélkül.\n\nÜdvözlettel,\nA támogatási csapat`
    },
    indonesian: {
        subject: 'Atur ulang kata sandi',
        text: (resetLink: string) => `Halo,\n\nKami menerima permintaan untuk mengatur ulang kata sandi akun Anda.\n\nUntuk melanjutkan dan menetapkan kata sandi baru, silakan klik tautan aman di bawah ini:\n\n${resetLink}\n\nTautan ini bersifat pribadi dan berlaku selama 15 menit.\n\nJika Anda tidak mengajukan permintaan ini, tidak diperlukan tindakan apa pun. Akun Anda akan tetap aman tanpa perubahan.\n\nHormat kami,\nTim dukungan`
    },
    italian: {
        subject: 'Reimpostazione della password',
        text: (resetLink: string) => `Salve,\n\nÈ stata effettuata una richiesta di reimpostazione della password per il tuo account.\n\nPer continuare e impostare una nuova password, fai clic sul link sicuro qui sotto:\n\n${resetLink}\n\nQuesto link è personale ed è valido per 15 minuti.\n\nSe non hai effettuato tu questa richiesta, non è necessaria alcuna azione. Il tuo account rimarrà sicuro senza modifiche.\n\nCordiali saluti,\nIl team di supporto`
    },
    japanese: {
        subject: 'パスワードの再設定',
        text: (resetLink: string) => `こんにちは。\n\nお客様のアカウントに対して、パスワード再設定のリクエストが行われました。\n\n続行して新しいパスワードを設定するには、以下の安全なリンクをクリックしてください。\n\n${resetLink}\n\nこのリンクは個人専用で、有効期限は15分です。\n\nこのリクエストに心当たりがない場合は、何も操作する必要はありません。アカウントは引き続き安全に保たれます。\n\nよろしくお願いいたします。\nサポートチーム`
    },
    korean: {
        subject: '비밀번호 재설정',
        text: (resetLink: string) => `안녕하세요.\n\n귀하의 계정에 대한 비밀번호 재설정 요청이 접수되었습니다.\n\n계속 진행하여 새 비밀번호를 설정하려면 아래의 보안 링크를 클릭해 주세요:\n\n${resetLink}\n\n이 링크는 개인 전용이며 15분 동안 유효합니다.\n\n본 요청을 직접 하신 것이 아니라면 아무 조치도 필요하지 않습니다. 계정은 안전하게 유지됩니다.\n\n감사합니다.\n지원팀`
    },
    lithuanian: {
        subject: 'Slaptažodžio atkūrimas',
        text: (resetLink: string) => `Sveiki,\n\nGauta užklausa atkurti jūsų paskyros slaptažodį.\n\nNorėdami tęsti ir nustatyti naują slaptažodį, spustelėkite žemiau pateiktą saugią nuorodą:\n\n${resetLink}\n\nŠi nuoroda yra asmeninė ir galioja 15 minučių.\n\nJei šios užklausos nepateikėte jūs, jokių veiksmų imtis nereikia. Jūsų paskyra liks saugi be jokių pakeitimų.\n\nPagarbiai,\nPagalbos komanda`
    },
    malay: {
        subject: 'Tetapkan semula kata laluan',
        text: (resetLink: string) => `Hai,\n\nKami telah menerima permintaan untuk menetapkan semula kata laluan akaun anda.\n\nUntuk meneruskan dan menetapkan kata laluan baharu, sila klik pautan selamat di bawah:\n\n${resetLink}\n\nPautan ini adalah peribadi dan sah selama 15 minit.\n\nJika anda tidak membuat permintaan ini, tiada tindakan diperlukan. Akaun anda akan kekal selamat tanpa sebarang perubahan.\n\nSalam hormat,\nPasukan sokongan`
    },
    norwegian: {
        subject: 'Tilbakestilling av passord',
        text: (resetLink: string) => `Hei,\n\nDet er mottatt en forespørsel om tilbakestilling av passordet til kontoen din.\n\nFor å fortsette og angi et nytt passord, vennligst klikk på den sikre lenken nedenfor:\n\n${resetLink}\n\nDenne lenken er personlig og gyldig i 15 minutter.\n\nHvis du ikke har bedt om denne tilbakestillingen, trenger du ikke å foreta deg noe. Kontoen din vil forbli sikker uten endringer.\n\nVennlig hilsen,\nSupportteamet`
    },
    polish: {
        subject: 'Resetowanie hasła',
        text: (resetLink: string) => `Witaj,\n\nOtrzymaliśmy prośbę o zresetowanie hasła do Twojego konta.\n\nAby kontynuować i ustawić nowe hasło, kliknij w bezpieczny link poniżej:\n\n${resetLink}\n\nTen link jest osobisty i ważny przez 15 minut.\n\nJeśli nie wysłałeś(-aś) tej prośby, nie musisz podejmować żadnych działań. Twoje konto pozostanie bezpieczne bez zmian.\n\nZ poważaniem,\nZespół wsparcia`
    },
    portuguese: {
        subject: 'Redefinição da palavra-passe',
        text: (resetLink: string) => `Olá,\n\nFoi efetuado um pedido para redefinir a palavra-passe da sua conta.\n\nPara continuar e definir uma nova palavra-passe, clique no link seguro abaixo:\n\n${resetLink}\n\nEste link é pessoal e válido por 15 minutos.\n\nSe não efetuou este pedido, não é necessária qualquer ação. A sua conta permanecerá segura sem alterações.\n\nCom os melhores cumprimentos,\nA equipa de suporte`
    },
    romanian: {
        subject: 'Resetarea parolei',
        text: (resetLink: string) => `Bună,\n\nA fost solicitată resetarea parolei pentru contul tău.\n\nPentru a continua și a seta o parolă nouă, te rugăm să dai clic pe linkul securizat de mai jos:\n\n${resetLink}\n\nAcest link este personal și valabil timp de 15 minute.\n\nDacă nu ai solicitat această resetare, nu este necesară nicio acțiune. Contul tău va rămâne securizat fără modificări.\n\nCu stimă,\nEchipa de suport`
    },
    russian: {
        subject: 'Сброс пароля',
        text: (resetLink: string) => `Здравствуйте,\n\nПоступил запрос на сброс пароля для вашей учетной записи.\n\nЧтобы продолжить и установить новый пароль, пожалуйста, перейдите по защищённой ссылке ниже:\n\n${resetLink}\n\nЭта ссылка является персональной и действительна в течение 15 минут.\n\nЕсли вы не запрашивали сброс пароля, никаких действий предпринимать не нужно. Ваша учетная запись останется в безопасности без изменений.\n\nС уважением,\nСлужба поддержки`
    },
    slovak: {
        subject: 'Obnovenie hesla',
        text: (resetLink: string) => `Dobrý deň,\n\nBola podaná žiadosť o obnovenie hesla k vášmu účtu.\n\nPre pokračovanie a nastavenie nového hesla kliknite, prosím, na zabezpečený odkaz nižšie:\n\n${resetLink}\n\nTento odkaz je osobný a platný 15 minút.\n\nAk ste túto žiadosť nepodali vy, nie je potrebné vykonať žiadne kroky. Váš účet zostane zabezpečený bez zmien.\n\nS pozdravom,\nTím podpory`
    },
    slovenian: {
        subject: 'Ponastavitev gesla',
        text: (resetLink: string) => `Pozdravljeni,\n\nPrejeli smo zahtevo za ponastavitev gesla za vaš račun.\n\nZa nadaljevanje in nastavitev novega gesla kliknite spodnjo varno povezavo:\n\n${resetLink}\n\nTa povezava je osebna in velja 15 minut.\n\nČe te zahteve niste poslali vi, ni potrebno nobeno dejanje. Vaš račun bo ostal varen brez sprememb.\n\nLep pozdrav,\nEkipa za podporo`
    },
    spanish: {
        subject: 'Restablecimiento de contraseña',
        text: (resetLink: string) => `Hola,\n\nSe ha solicitado el restablecimiento de la contraseña de tu cuenta.\n\nPara continuar y establecer una nueva contraseña, haz clic en el enlace seguro que aparece a continuación:\n\n${resetLink}\n\nEste enlace es personal y válido durante 15 minutos.\n\nSi no has solicitado este restablecimiento, no es necesario realizar ninguna acción. Tu cuenta permanecerá segura sin cambios.\n\nAtentamente,\nEl equipo de soporte`
    },
    swedish: {
        subject: 'Återställning av lösenord',
        text: (resetLink: string) => `Hej,\n\nEn begäran om att återställa lösenordet för ditt konto har mottagits.\n\nFör att fortsätta och ange ett nytt lösenord, klicka på den säkra länken nedan:\n\n${resetLink}\n\nDenna länk är personlig och giltig i 15 minuter.\n\nOm du inte har begärt denna återställning behöver du inte vidta några åtgärder. Ditt konto förblir säkert utan ändringar.\n\nVänliga hälsningar,\nSupportteamet`
    },
    thai: {
        subject: 'รีเซ็ตรหัสผ่าน',
        text: (resetLink: string) => `สวัสดี,\n\nมีการส่งคำขอรีเซ็ตรหัสผ่านสำหรับบัญชีของคุณ\n\nหากต้องการดำเนินการต่อและตั้งรหัสผ่านใหม่ โปรดคลิกลิงก์ที่ปลอดภัยด้านล่าง:\n\n${resetLink}\n\nลิงก์นี้เป็นลิงก์ส่วนบุคคลและมีอายุการใช้งาน 15 นาที\n\nหากคุณไม่ได้เป็นผู้ส่งคำขอนี้ ไม่จำเป็นต้องดำเนินการใด ๆ บัญชีของคุณจะยังคงปลอดภัยโดยไม่มีการเปลี่ยนแปลง\n\nขอแสดงความนับถือ,\nทีมสนับสนุน`
    },
    turkish: {
        subject: 'Parola sıfırlama',
        text: (resetLink: string) => `Merhaba,\n\nHesabınız için bir parola sıfırlama talebi alınmıştır.\n\nDevam etmek ve yeni bir parola belirlemek için lütfen aşağıdaki güvenli bağlantıya tıklayın:\n\n${resetLink}\n\nBu bağlantı kişiseldir ve 15 dakika boyunca geçerlidir.\n\nBu talebi siz yapmadıysanız herhangi bir işlem yapmanıza gerek yoktur. Hesabınız değişiklik olmadan güvende kalacaktır.\n\nSaygılarımızla,\nDestek Ekibi`
    },
    ukrainian: {
        subject: 'Скидання пароля',
        text: (resetLink: string) => `Вітаємо,\n\nНадійшов запит на скидання пароля для вашого облікового запису.\n\nЩоб продовжити та встановити новий пароль, будь ласка, перейдіть за захищеним посиланням нижче:\n\n${resetLink}\n\nЦе посилання є персональним і дійсне протягом 15 хвилин.\n\nЯкщо ви не надсилали цей запит, жодних дій виконувати не потрібно. Ваш обліковий запис залишиться захищеним без змін.\n\nЗ повагою,\nКоманда підтримки`
    },
    vietnamese: {
        subject: 'Đặt lại mật khẩu',
        text: (resetLink: string) => `Xin chào,\n\nChúng tôi đã nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.\n\nĐể tiếp tục và thiết lập mật khẩu mới, vui lòng nhấp vào liên kết bảo mật bên dưới:\n\n${resetLink}\n\nLiên kết này là cá nhân và có hiệu lực trong 15 phút.\n\nNếu bạn không thực hiện yêu cầu này, bạn không cần thực hiện bất kỳ hành động nào. Tài khoản của bạn sẽ vẫn được bảo mật mà không có thay đổi.\n\nTrân trọng,\nĐội ngũ hỗ trợ`
    },
};