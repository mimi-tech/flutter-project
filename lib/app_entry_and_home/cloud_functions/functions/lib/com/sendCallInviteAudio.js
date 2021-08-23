'use-strict'

const functions = require('firebase-functions');
const admin     = require('firebase-admin');

exports.sendCallInviteAudio = functions.firestore
.document("calls/{friendId}/date/{dateId}/audioCallInvite/{myId}")
.onWrite((change,context)=> {

  const friendId = context.params.friendId;
  const myId     = context.params.myId;
  const dateId   = context.params.dateId;
  const db       = admin.firestore();

  console.log("friend id: " + friendId + " audio call initiator: " + myId);

  return db.collection("calls").doc(friendId)
  .collection("date").doc(dateId)
  .collection("audioCallInvite").doc(myId)
  .get().then((queryResult)=>{

    const f_id            = queryResult.data().id;
    const f_nm            = queryResult.data().nm;
    const f_un            = queryResult.data().un;
    const f_em            = queryResult.data().em;
    const f_pimg          = queryResult.data().pimg;
    //const f_tkn           = queryResult.data().tkn;
    const f_chn           = queryResult.data().chn;
    const f_encryptionKey = queryResult.data().ek;
    const f_ts            = queryResult.data().ts;
    const f_idsc          = queryResult.data().idsc;
    const f_nmsc          = queryResult.data().nmsc;
    const f_unmsc         = queryResult.data().unmsc;
    const f_pimgsc        = queryResult.data().pimgsc;

    //const f_data = db.collection("users").doc(myId).get();
    //const t_data = db.collection("users").doc(friendId).get();
    //return Promise.all([f_data, t_data]).then(result=>{
    //const t_nm    = result[1].data().nm;
    //const t_token = result[1].data().tkn;
  
    const payload={
      // notification:{
      //   title:f_nm,
      //   body:"is audio calling you."
      // },
      data:{
        id:f_id,
        nm:f_nm,
        un: f_un,
        em:f_em,
        pimg:f_pimg,
        chn:f_chn,
        ek:f_encryptionKey,
        ts:f_ts,
        idsc:f_idsc,
        nmsc:f_nmsc,
        unmsc:f_unmsc,
        pimgsc:f_pimgsc,
        ca:"TARGET_CALLINVITEAUDIO",
        click_action:"FLUTTER_NOTIFICATION_CLICK"
      }
    };
    
    //console.log(" | to: " + t_nm + " | from:" + f_nm + " | message:" + f_nm + " is audio calling you.");

    return admin.messaging().sendToTopic(friendId, payload)
    
    .then((response) => {

    console.log("Successfully sent audio call invite notification to topic id: ", friendId, response);
    
    return null;
  
    }).catch((error)  => {

      console.error("Failure sending audio call invite notification to topic id: ", friendId, error);

    });
  
  });

});