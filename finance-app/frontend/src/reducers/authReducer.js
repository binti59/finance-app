const initialState = {
  isAuthenticated: true,
  loading: false,
  user: {
    name: 'John Doe',
    email: 'john@example.com'
  },
  error: null
};

export default function(state = initialState, action) {
  const { type, payload } = action;
  
  switch (type) {
    case 'USER_LOADED':
      return {
        ...state,
        isAuthenticated: true,
        loading: false,
        user: payload
      };
    case 'LOGIN_SUCCESS':
    case 'REGISTER_SUCCESS':
      return {
        ...state,
        ...payload,
        isAuthenticated: true,
        loading: false
      };
    case 'AUTH_ERROR':
    case 'LOGIN_FAIL':
    case 'REGISTER_FAIL':
    case 'LOGOUT':
      return {
        ...state,
        token: null,
        isAuthenticated: false,
        loading: false,
        user: null,
        error: payload
      };
    default:
      return state;
  }
}
