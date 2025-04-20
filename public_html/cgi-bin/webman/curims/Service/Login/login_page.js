new Vue({
    el: '#app',
    data: {
      login: '',
      password: ''
    },
    methods: {
      guestLogin() {
        // Redirect to guest login
        window.location.href = 'index.cgi?login=guest&password=guest';
      },
      submitForm() {
        // Submit form manually
        if (this.login && this.password) {
          const form = document.createElement('form');
          form.method = 'POST';
          form.action = 'index.cgi';
  
          const loginInput = document.createElement('input');
          loginInput.type = 'hidden';
          loginInput.name = 'login';
          loginInput.value = this.login;
          form.appendChild(loginInput);
  
          const passwordInput = document.createElement('input');
          passwordInput.type = 'hidden';
          passwordInput.name = 'password';
          passwordInput.value = this.password;
          form.appendChild(passwordInput);
  
          const submitInput = document.createElement('input');
          submitInput.type = 'hidden';
          submitInput.name = 'button_submit';
          submitInput.value = 'Login';
          form.appendChild(submitInput);
  
          document.body.appendChild(form);
          form.submit();
        } else {
          alert('Please enter both User ID and Password.');
        }
      }
    }
  });
  