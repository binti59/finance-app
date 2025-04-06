import { combineReducers } from 'redux';
import authReducer from './authReducer';
import notificationReducer from './notificationReducer';
import goalsReducer from './goalsReducer';

export default combineReducers({
  auth: authReducer,
  notification: notificationReducer,
  goals: goalsReducer
});
