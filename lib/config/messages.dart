/*
* Here all the message that app show to users
* */

class Messages {
  static const HAS_NO_LINKED_ACCOUNT = 'This email has no linked account!';
  static const INVALID_CODE = 'Invalid code please check your email!';
  static const INVALID_EMAIL_OR_PASSWORD = 'Invalid email or password!';
  static const INVALID_TOKEN_OR_EXPIRED = 'The token is invalid or expired!';
  static const INVALID_OLD_PASSWORD = 'Invalid old password!';
  static const EMAIL_ALREADY_EXISTS = 'This email already exists!';
  static const NO_TENTATIVE_SEND_CODE_LEFT = 'Sorry all send code tentative is consumed!';
  static const THE_LAST_TENTATIVE_SEND_CODE_LEFT = 'This is the last send code tentative!';
  static const SAVED_SUCCESS = 'Saved successfully!';
  static const SAVED_FAILURE = 'Saving failed, please try again!';
  static const EVENT_ALREADY_FAVOURITE = 'This event is already in your favorite!';
  static const MY_PURCHASED_TICKETS = 'My Tickets';
  static const EVENT_NOT_EXISTS = 'This event does not exist anymore!';
  static const EVENTS_NOT_EXISTS = 'Sorry events does not exists!';
  static const TICKETS_NOT_EXISTS = 'Tickets are currently unavailable. Please check back later or reach out to the event organiser';
  static const EVENT_ALREADY_FINISHED = 'This event already finished. ';
  static const ONLY_LETTER_AND_NUMBER = 'Only letters and numbers allowed';
  static const ONLY_LETTERS = 'Only letters allowed';
  static const UNIVERSITY_MISSING = 'No University selected!';
  static const PASSWORD_NOT_COMPLEX = 'Password not complex enough!';
  static const REQUIRED = '*Required';
  static const EVENT_STARTED = 'Event Started';
  static const EVENT_LIVE = 'Event Live';
  static const EVENT_ENDED = 'Event Ended';

  static const ENTER_VALID_EMAIL = 'Enter valid email';

  static const CHECKOUT_SUCCESS = 'Your checkout has been successfully processed!';
  static const CHECKOUT_SUCCESSFULLY = 'Check out Successfully';
  static const CHECKOUT_CANCEL = 'Your checkout has been canceled!';
  static const EVENT_NOT_EXISTS_FOR_PURCHASE = 'Sorry, this event not exists for purchase!';
  static const SOCIETY_HAVE_NO_STRIPE = 'Sorry, this event society has no payment gateway for now!';
  static const NO_CONNECTION = 'Please verify your connection!';
  static const SERVER_FAILURE = 'There was a problem please try later!';
  static const NO_TICKET_DESC = 'No description yet for this ticket!';
  static const CODE_SENT = 'Please check your email for the received code!';
  static const SOCIETY_NOT_EXISTS = 'This society does not exist anymore!';
  static const ORDER_NOT_REFUNDABLE = 'Sorry! this order not refundable from the society!';
  static const REFUND_ISSUED = 'Refund Sent';
  static const SOCIETY_ALREADY_FOLLOWED = 'Society already followed!';
  static const SOCIETY_FOLLOWED = 'Society followed successfully!';
  static const SOCIETY_UNFOLLOWED = 'Society unfollowed successfully!';
  static const ALREADY_REFUNDED = 'The order is already refunded!';
  static const FIRST_FOLLOWER = 'Yoo! Congrats you\'re the first follower of the society';
  static const FRIEND_REQUEST_SENT = 'Friend request sent successfully!';
  static const UPCOMING = 'Upcoming';
  static const RECENTLY_ADDED = 'Recently Added';
  static const OLDEST = 'Oldest';
  static const DESC = 'Descending';
  static const ONLINE = 'Online';
  static const STANDARD = 'Standard';
  static const DATE = 'Date';
  static const DISTANCE = 'Distance';
  static const EVENT_TYPE = 'Event Type';
  static const ASC = 'Ascending';
  static const EVENT_UNREFUNDABLE_MSG = 'Sorry! the event of this order is unrefundable from the society';
  static const FREE_EVENT_MSG = 'Sorry! you can\'t make refund for Free events';
  static const SECURE_PAYMENT = 'Secure payment';
  static const IN_CART = 'In Cart';
  static const LIMIT_FREE_TICKET = 'You reached the limit of free ticket for this event';
  static const PAST_TICKETS = 'Past Tickets';
  static const INVITATIONS = 'Invitations';
  static const CHAT = 'Chat';
  static const SEARCH_EVENTS = 'Search Events..';
  static const SEARCH_SOCIETIES = 'Search Societies..';
  static const SEARCH_STUDENTS = 'Search Students..';
  static const FOLLOWED_SOCIETIES = 'Followed Societies';
  static const ALREADY_SEND_INVITATION = 'You already sent invitation request to this student!';
  static const INVALID_FILLED_INFO = 'Filled information invalid!';
  static const ACCEPT = 'Accept';
  static const ACCEPTED = 'Accepted';
  static const REJECTED = 'Rejected';
  static const REST_PASSWORD_TEXT = 'Please enter your email address, We will send you a code for resetting your password!';
  static const SET_NEW_PASSWORD_TEXT = 'Let\'s change your password with a new one!';
  static const ACTIVATE_ACCOUNT_TEXT = 'Please check your emails an activate code is already sent!';
  static const LOGIN_TXT = 'Please login to continue!';
  static const REFRESH_TEXT_BTN = 'Try Again';

  // Refund Page
  static var REFUND_POLICY = 'You can request refund if It’s less than 48 hours since you purchase the order and the event not start yet.';
  static var REFUND_TIME = 'Refunds take 5-10 days to appear on a customer’s statement';

  // Stripe Code
  static const CODE_INTERNAL_ERROR = 0;
  static const CODE_INVALID_DATA = 1;
  static const CODE_UN_AUTHORIZED = 2;
  static const CODE_MISSING_DATA = 3;
  static const CODE_DOESNT_EXIST = 4;
  static const CODE_CREATE_ERROR = 5;
  static const CODE_UPDATE_ERROR = 6;
  static const CODE_UPDATE_CREATE_ERROR = 7;
  static const CODE_DELETE_ERROR = 8;
  static const CODE_ALREADY_EXISTS = 9;
  static const CODE_ACCOUNT_INACTIVE = 10;
  static const CODE_ACCOUNT_SUSPENDED = 11;
  static const CODE_SENDING_ERROR = 12;
  static const CODE_PHONE_NOT_VERIFIED = 13;
  static const CODE_INVALID_OAUTH_TOKEN = 14;
  static const CODE_ACCOUNT_NOT_SUBSCRIBED = 15;
  static const CODE_INVALID_TOKEN = 16;
  static const CODE_INVALID_SYSTEM_DATA = 17;
  static const CODE_NOT_EQUAL = 18;
  static const CODE_PASSWORD_NOT_COMPLEX = 19;
  static const CODE_COMMON_EXCEPTION = 20;
  static const CODE_UNABLE_TO_TAKE_PAYMENT = 21;
  static const CODE_INVALID_GATEWAY_REQUEST_ERROR = 22;
  static const CODE_PAYMENT_ERROR = 23;
  static const CODE_UNABLE_TO_PLACE_ORDER = 24;
  static const CODE_EMPTY_LINE_ITEMS = 25;
  static const CODE_PAYMENT_ALEADY_EXISTS = 26;
  static const CODE_STRIPE_UNAUTHORIZED = 27;
  static const CODE_DIFFERENT_CURRENCY = 28;
  static const CODE_ORDER_PRICE_TOO_LOW = 29;
  static const CODE_BASKET_THRESHOLD_REACHED = 30;
  static const CODE_STRIPE_NOT_CONNECTED = 31;
  static const CODE_INVALID_PAYLOAD = 32;
  static const CODE_INVALID_SIGNATURE = 33;

  // REFUND API RESPONSE
  static const CODE_EVENT_UNREFUNDABLE = 34;
  static const CODE_STRIPE_RATE_LIMIT_ERROR = 35;
  static const CODE_STRIPE_API_CONNECTION_ERROR = 36;
  static const CODE_STRIPE_INVALID_REQUEST_ERROR = 37;
  static const CODE_STRIPE_ERROR = 38;
  static const CODE_FREE_EVENT = 39;

  // Free Order API RESPONSE
  static const CODE_ALLOCATION_CONSUPTION_NOT_POSSIBLE = 41;
  static const CODE_ORDERED_QTY_GREATER_THAN_REQUESTED_QTY = 42;
}
