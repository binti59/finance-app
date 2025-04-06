import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import {
  Container,
  Paper,
  Typography,
  Box
} from '@material-ui/core';

const useStyles = makeStyles((theme) => ({
  root: {
    display: 'flex',
    flexDirection: 'column',
    minHeight: '100vh',
    backgroundColor: theme.palette.background.default,
  },
  container: {
    marginTop: theme.spacing(8),
    marginBottom: theme.spacing(8),
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
  paper: {
    padding: theme.spacing(4),
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    width: '100%',
    maxWidth: 450,
  },
  logo: {
    marginBottom: theme.spacing(2),
  },
  footer: {
    padding: theme.spacing(3, 2),
    marginTop: 'auto',
    backgroundColor: theme.palette.background.paper,
  },
}));

const AuthLayout = ({ children }) => {
  const classes = useStyles();

  return (
    <div className={classes.root}>
      <Container component="main" className={classes.container}>
        <Paper className={classes.paper} elevation={3}>
          <Typography variant="h4" component="h1" className={classes.logo}>
            Finance Manager
          </Typography>
          {children}
        </Paper>
      </Container>
      <Box component="footer" className={classes.footer}>
        <Container maxWidth="sm">
          <Typography variant="body2" color="textSecondary" align="center">
            © {new Date().getFullYear()} Finance Manager. All rights reserved.
          </Typography>
        </Container>
      </Box>
    </div>
  );
};

export default AuthLayout;
