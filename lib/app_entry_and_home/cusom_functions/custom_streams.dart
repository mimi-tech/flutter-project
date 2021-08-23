import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparks/app_entry_and_home/services/databaseService.dart';

class CustomStreams {

  //TODO: This function keeps updating the like/comments/share counter whenever a post is liked/commented/shared.
  /*
  * Where loggedInUser is the current user id.
  *       authorID is the id of the user who created the post.
  *       postID is the id of the post.
  * */
  static Stream<DocumentSnapshot> currentNumberOfLikesCommentsShare(String? loggedInUser, String? authorID, String? postID) {
    Stream<DocumentSnapshot> likeCommentShareSnapshot = DatabaseService(loggedInUserID: loggedInUser).getCurrentLikesCommentShareCounter(authorID, postID);
    return likeCommentShareSnapshot;
  }

  //TODO: Updates the like counter whenever a user likes/dislikes a comment
  static Stream<DocumentSnapshot> currentNumberOfLikedCommentAndReplies(String? loggedInUser, String? authorID, String? postID, String? commentId) {
    Stream<DocumentSnapshot> likeCommentReplySnapshot = DatabaseService(loggedInUserID: loggedInUser).getCurrentLikeCommentCounter(authorID, postID, commentId);
    return likeCommentReplySnapshot;
  }

}