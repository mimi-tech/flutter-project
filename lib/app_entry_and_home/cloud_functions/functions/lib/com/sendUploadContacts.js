'use-strict'

const functions  = require('firebase-functions');
const admin      = require('firebase-admin');
const FieldValue = require('firebase-admin').firestore.FieldValue;

exports.sendUploadContacts = functions.firestore
.document("users/{userId}/contactsUpload/{uploadBatch}")
.onWrite((change, context) => {

    const db          = admin.firestore();
    const userId      = context.params.userId;
    const uploadBatch = context.params.uploadBatch;

    console.log(userId + " uploading contacts batch " + uploadBatch);

    const toRef = db.collection('users').doc(userId);

    return db.collection("users").doc(userId)
    .collection("contactsUpload").doc(uploadBatch)
    .get()
    .then((queryResult) => {

        const batch = queryResult.data().batch;

        const complete = queryResult.data().complete;

        toRef
        .set(
            {
                contactsUploaded: true,
                contactsSynced: false,
            }, { merge: true }
        );

        var i;

        for (i = 0; i < batch.length; i++) {

            db.collection('users')
            .where('ph', '==', batch[i].get("ph"))
            .get()
            .then(snapshot => {

                if (snapshot.empty) {

                    console.log('No matching documents.');

                    return null;
                }
                else {

                    snapshot.forEach(doc => {

                        console.log(doc.id, '=>', data);

                        db
                        .collection('users')
                        .doc(doc.id)
                        .set(
                            {

                                contacts: FieldValue.arrayUnion(userId),

                            }, { merge: true }
                        );

                    });

                    return null;

                }

            }).catch(err => {

                console.log('Error getting documents', err);

            });
                
        }

        if (complete) {

            toRef
            .set(
                {
                    contactsSynced: true,
                }, { merge: true }
            );

        }

        return null;

    }).catch((err) => {
        
        throw err;

    });

});