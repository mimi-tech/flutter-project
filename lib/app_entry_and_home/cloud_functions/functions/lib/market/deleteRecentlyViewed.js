'use-strict'

const functions = require('firebase-functions');
const admin = require('firebase-admin');

exports.deleteRecentlyViewed = functions.firestore
  .document("users/{userId}/Market/marketInfo/marketRecentlyViewed/{doc}")
  .onDelete((snap, context) => {

    const collectionPath = `users/{userId}/Market/marketInfo/marketRecentlyViewed`;

    // perform desired operations ...

    async function deleteRecentlyDoc() {
      const db = admin.firestore()
      const docLocation = db
      .collection('users')
      .doc(context.params.userId)
      .collection("Market")
      .doc("marketInfo")
      .collection("marketRecentlyViewed")
      .limit(3000);

      return new Promise((resolve, reject) => {
        deleteInBatches(db, docLocation, resolve).then(doc => {
          console.log("marketRecentlyViewed collection deleted successfully");
        }).catch(reject);
      });
    }

    async function deleteInBatches(db, query, resolve) {
      const snapshot = await query.get();

      const batchSize = snapshot.size;

      if(batchSize === 0) {
        resolve();
        return;
      }

      const batch = db.batch();
      snapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
      });
      await batch.commit();


      process.nextTick(() => {
        deleteQueryBatch(db, query, resolve);
      });
      
    } 


    try {
      deleteRecentlyDoc();
    } catch (error) {
      console.log("Deleting marketRecentlyViewed encountered an error");
    }

  });