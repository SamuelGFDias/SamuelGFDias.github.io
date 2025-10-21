const { onCall, HttpsError } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

// Configuração da região (padrão é us-central1)
const functionsConfig = { region: 'us-central1' };

function isNonEmptyString(v) { return typeof v === 'string' && v.trim().length > 0; }
function validateContent(data) {
  if (typeof data !== 'object' || data === null) throw new Error('payload inválido');
  if (!data.hero || !isNonEmptyString(data.hero.title) || !isNonEmptyString(data.hero.subtitle)) throw new Error('hero inválido');
  if (!data.about || !isNonEmptyString(data.about.title) || !isNonEmptyString(data.about.description)) throw new Error('about inválido');
  if (!data.skills || !isNonEmptyString(data.skills.title) || !Array.isArray(data.skills.items)) throw new Error('skills inválido');
  for (const g of data.skills.items) { if (!isNonEmptyString(g.skill) || !Array.isArray(g.items)) throw new Error('skill group inválido'); for (const it of g.items) if (!isNonEmptyString(it)) throw new Error('skill item inválido'); }
  if (!data.projects || !isNonEmptyString(data.projects.title) || !Array.isArray(data.projects.items)) throw new Error('projects inválido');
  for (const p of data.projects.items) { if (!isNonEmptyString(p.title) || !isNonEmptyString(p.description)) throw new Error('project inválido'); }
  if (!Array.isArray(data.links)) throw new Error('links inválido');
  for (const l of data.links) { if (!isNonEmptyString(l.icon) || !isNonEmptyString(l.url) || !isNonEmptyString(l.tooltip)) throw new Error('link inválido'); }
  return true;
}

exports.getHomeContent = onCall(functionsConfig, async () => {
  const snap = await db.doc('cms/home').get();
  return snap.exists ? snap.data() : null;
});

exports.updateHomeContent = onCall(functionsConfig, async (request) => {
  if (!request.auth || request.auth.token.admin !== true) {
    throw new HttpsError('permission-denied', 'Somente admin pode alterar o conteúdo');
  }
  const data = request.data;
  try { validateContent(data); } catch (e) { throw new HttpsError('invalid-argument', e.message); }
  await db.doc('cms/home').set(data, { merge: false });
  return { ok: true };
});