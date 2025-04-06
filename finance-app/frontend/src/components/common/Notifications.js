import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import { Snackbar, IconButton } from '@material-ui/core';
import { Close as CloseIcon } from '@material-ui/icons';
import { useSelector, useDispatch } from 'react-redux';
import { clearNotification } from '../../actions/notificationActions';

const useStyles = makeStyles((theme) => ({
  close: {
    padding: theme.spacing(0.5),
  },
}));

const Notifications = () => {
  const classes = useStyles();
  const dispatch = useDispatch();
  const { message, type, open } = useSelector(state => state.notification);

  const handleClose = (event, reason) => {
    if (reason === 'clickaway') {
      return;
    }
    dispatch(clearNotification());
  };

  return (
    <Snackbar
      anchorOrigin={{
        vertical: 'bottom',
        horizontal: 'left',
      }}
      open={open}
      autoHideDuration={6000}
      onClose={handleClose}
      message={message}
      action={
        <IconButton
          size="small"
          aria-label="close"
          color="inherit"
          className={classes.close}
          onClick={handleClose}
        >
          <CloseIcon fontSize="small" />
        </IconButton>
      }
    />
  );
};

export default Notifications;
