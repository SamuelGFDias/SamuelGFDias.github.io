import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

/// Uma classe para substituir os textos padrões do Firebase UI Auth para o Português do Brasil.
/// Isso é útil para traduzir mensagens de erro específicas que não são cobertas
/// pela tradução padrão do pacote.
class PtBrFirebaseUILocalizations extends FirebaseUILocalizationLabels {
  const PtBrFirebaseUILocalizations();

  @override
  String get accessDisabledErrorText => 'Acesso desativado.';

  @override
  String get arrayLabel => 'Array';

  @override
  String get booleanLabel => 'Booleano';

  @override
  String get cancelButtonLabel => 'Cancelar';

  @override
  String get cancelLabel => 'Cancelar';

  @override
  String get checkEmailHintText => 'Verifique seu e-mail para continuar.';

  @override
  String get chooseACountry => 'Escolha um país';

  @override
  String get confirmDeleteAccountAlertMessage =>
      'Tem certeza de que deseja excluir sua conta? Esta ação é irreversível.';

  @override
  String get confirmDeleteAccountAlertTitle => "Excluir conta";

  @override
  String get confirmDeleteAccountButtonLabel => "Sim, excluir";

  @override
  String get confirmPasswordDoesNotMatchErrorText => "As senhas não coincidem.";

  @override
  String get confirmPasswordInputLabel => "Confirmar senha";

  @override
  String get confirmPasswordIsRequiredErrorText =>
      "Confirmação de senha é obrigatória.";

  @override
  String get confirmUnlinkButtonLabel => "Desvincular";

  @override
  String get continueText => "Continuar";

  @override
  String get countryCode => "Código do país";

  @override
  String get credentialAlreadyInUseErrorText =>
      "Esta credencial já está em uso por outra conta.";

  @override
  String get deleteAccount => "Excluir conta";

  @override
  String get differentMethodsSignInTitleText => "Entrar com métodos diferentes";

  @override
  String get disable => "Desativar";

  @override
  String get dismissButtonLabel => "Dispensar";

  @override
  String get doneButtonLabel => "Concluído";

  @override
  String get eastInitialLabel => "Leste";

  @override
  String get emailInputLabel => "E-mail";

  @override
  String get emailIsNotVerifiedText => "Seu e-mail não foi verificado.";

  @override
  String get emailIsRequiredErrorText => "E-mail é obrigatório.";

  @override
  String get emailLinkSignInButtonLabel => "Entrar com link de e-mail";

  @override
  String get emailTakenErrorText => "Este e-mail já está em uso.";

  @override
  String get enable => "Ativar";

  @override
  String get enableMoreSignInMethods => "Ativar mais métodos de login";

  @override
  String get enterSMSCodeText => "Digite o código SMS";

  @override
  String get findProviderForEmailTitleText => "Encontrar provedor para e-mail";

  @override
  String get forgotPasswordButtonLabel => "Esqueceu a senha?";

  @override
  String get forgotPasswordHintText =>
      "Digite seu e-mail para redefinir sua senha.";

  @override
  String get forgotPasswordViewTitle => "Redefinir senha";

  @override
  String get geopointLabel => "Geoponto";

  @override
  String get goBackButtonLabel => "Voltar";

  @override
  String get invalidCountryCode => "Código de país inválido.";

  @override
  String get invalidVerificationCodeErrorText =>
      "Código de verificação inválido.";

  @override
  String get isNotAValidEmailErrorText => "E-mail inválido.";

  @override
  String get latitudeLabel => "Latitude";

  @override
  String get linkEmailButtonText => "Vincular e-mail";

  @override
  String get longitudeLabel => "Longitude";

  @override
  String get mapLabel => "Mapa";

  @override
  String get mfaTitle => "Autenticação multifator";

  @override
  String get name => "Nome";

  @override
  String get northInitialLabel => "Norte";

  @override
  String get nullLabel => "Nulo";

  @override
  String get numberLabel => "Número";

  @override
  String get off => "Desligado";

  @override
  String get okButtonLabel => "OK";

  @override
  String get on => "Ligado";

  @override
  String get passwordInputLabel => "Senha";

  @override
  String get passwordIsRequiredErrorText => "Senha é obrigatória.";

  @override
  String get passwordResetEmailSentText =>
      "E-mail de redefinição de senha enviado.";

  @override
  String get phoneInputLabel => "Telefone";

  @override
  String get phoneNumberInvalidErrorText => "Número de telefone inválido.";

  @override
  String get phoneNumberIsRequiredErrorText =>
      "Número de telefone é obrigatório.";

  @override
  String get phoneVerificationViewTitleText => "Verificação de telefone";

  @override
  String get profile => "Perfil";

  @override
  String get provideEmail => "Forneça um e-mail";

  @override
  String get referenceLabel => "Referência";

  @override
  String get registerActionText => "Registrar";

  @override
  String get registerHintText => "Não tem uma conta?";

  @override
  String get registerText => "Registrar";

  @override
  String get resendVerificationEmailButtonLabel =>
      "Reenviar e-mail de verificação";

  @override
  String get resetPasswordButtonLabel => "Redefinir senha";

  @override
  String get sendLinkButtonLabel => "Enviar link";

  @override
  String get sendVerificationEmailLabel => "Enviar e-mail de verificação";

  @override
  String get signInActionText => "Entrar";

  @override
  String get signInHintText => "Já tem uma conta?";

  @override
  String get signInMethods => "Métodos de login";

  @override
  String get signInText => "Entrar";

  @override
  String get signInWithAppleButtonText => "Entrar com Apple";

  @override
  String get signInWithEmailLinkSentText => "Link de e-mail de login enviado.";

  @override
  String get signInWithEmailLinkViewTitleText => "Entrar com link de e-mail";

  @override
  String get signInWithFacebookButtonText => "Entrar com Facebook";

  @override
  String get signInWithGoogleButtonText => "Entrar com Google";

  @override
  String get signInWithPhoneButtonText => "Entrar com telefone";

  @override
  String get signInWithTwitterButtonText => "Entrar com Twitter";

  @override
  String get signOutButtonText => "Sair";

  @override
  String get smsAutoresolutionFailedError =>
      "Falha na resolução automática de SMS.";

  @override
  String get southInitialLabel => "Sul";

  @override
  String get stringLabel => "String";

  @override
  String get timestampLabel => "Timestamp";

  @override
  String get typeLabel => "Tipo";

  @override
  String get ulinkProviderAlertTitle => "Desvincular provedor";

  @override
  String get unknownError => "Erro desconhecido.";

  @override
  String get unlinkProviderAlertMessage =>
      "Tem certeza de que deseja desvincular este provedor?";

  @override
  String get updateLabel => "Atualizar";

  @override
  String get uploadButtonText => "Carregar";

  @override
  String get userNotFoundErrorText => "Usuário não encontrado.";

  @override
  String get valueLabel => "Valor";

  @override
  String get verificationEmailSentText => "E-mail de verificação enviado.";

  @override
  String get verificationEmailSentTextShort => "E-mail de verificação enviado.";

  @override
  String get verificationFailedText => "Verificação falhou.";

  @override
  String get verifyCodeButtonText => "Verificar código";

  @override
  String get verifyEmailTitle => "Verificar e-mail";

  @override
  String get verifyItsYouText => "Verifique se é você";

  @override
  String get verifyPhoneNumberButtonText => "Verificar número de telefone";

  @override
  String get verifyingSMSCodeText => "Verificando código SMS...";

  @override
  String get waitingForEmailVerificationText =>
      "Aguardando verificação de e-mail...";

  @override
  String get weakPasswordErrorText => "A senha é muito fraca.";

  @override
  String get westInitialLabel => "Oeste";

  @override
  String get wrongOrNoPasswordErrorText => "Senha incorreta ou não fornecida.";
}
