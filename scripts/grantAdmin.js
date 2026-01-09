const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccount.json');
admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
const uid = process.argv[2];
(async () => {
  if (!uid) { console.error('Uso: node grantAdmin.js <UID>'); process.exit(1); }
  await admin.auth().setCustomUserClaims(uid, { admin: true });
  console.log('Claim admin atribuída ao UID:', uid);
})();
  