export const setNotification = (message, type = 'info') => dispatch => {
  dispatch({
    type: 'SET_NOTIFICATION',
    payload: { message, type }
  });
};

export const clearNotification = () => dispatch => {
  dispatch({
    type: 'CLEAR_NOTIFICATION'
  });
};
