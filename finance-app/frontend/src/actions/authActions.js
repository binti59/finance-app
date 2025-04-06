export const loadUser = () => async dispatch => {
  try {
    // This would typically make an API call to get user data
    // For now, we'll just simulate a successful response
    dispatch({
      type: 'USER_LOADED',
      payload: {
        name: 'John Doe',
        email: 'john@example.com'
      }
    });
  } catch (err) {
    dispatch({
      type: 'AUTH_ERROR'
    });
  }
};

export const login = (email, password) => async dispatch => {
  try {
    // This would typically make an API call to authenticate
    // For now, we'll just simulate a successful response
    dispatch({
      type: 'LOGIN_SUCCESS',
      payload: {
        token: 'sample-token',
        user: {
          name: 'John Doe',
          email
        }
      }
    });
  } catch (err) {
    dispatch({
      type: 'LOGIN_FAIL',
      payload: 'Invalid credentials'
    });
  }
};

export const register = (name, email, password) => async dispatch => {
  try {
    // This would typically make an API call to register
    // For now, we'll just simulate a successful response
    dispatch({
      type: 'REGISTER_SUCCESS',
      payload: {
        token: 'sample-token',
        user: {
          name,
          email
        }
      }
    });
  } catch (err) {
    dispatch({
      type: 'REGISTER_FAIL',
      payload: 'Registration failed'
    });
  }
};

export const logout = () => dispatch => {
  dispatch({ type: 'LOGOUT' });
};
