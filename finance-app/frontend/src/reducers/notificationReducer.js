const initialState = {
  message: '',
  type: 'info',
  open: false
};

export default function(state = initialState, action) {
  const { type, payload } = action;
  
  switch (type) {
    case 'SET_NOTIFICATION':
      return {
        ...state,
        message: payload.message,
        type: payload.type || 'info',
        open: true
      };
    case 'CLEAR_NOTIFICATION':
      return {
        ...state,
        open: false
      };
    default:
      return state;
  }
}
