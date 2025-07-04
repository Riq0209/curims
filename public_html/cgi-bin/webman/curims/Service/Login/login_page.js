function guestLogin() {
  // Redirect to guest login
  window.location.href = 'index.cgi?login=guest&password=guest';
}

// Handle form submission with AJAX
document.getElementById('login-form').onsubmit = async function(event) {
  event.preventDefault(); // Always prevent default form submission
  
  const login = document.getElementById('login').value.trim();
  const password = document.getElementById('password').value;
  const errorElement = document.getElementById('error-message');
  const submitButton = document.querySelector('button[type="submit"]');
  
  // Basic validation
  if (!login || !password) {
    if (errorElement) {
      errorElement.textContent = 'Please enter both User ID and Password.';
      errorElement.style.display = 'block';
    } else {
      alert('Please enter both User ID and Password.');
    }
    return false;
  }
  
  try {
    // Disable submit button during request
    if (submitButton) {
      submitButton.disabled = true;
      submitButton.textContent = 'Signing in...';
    }
    
    // Send login request to login_check.cgi
    const response = await fetch('login_check.cgi', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: `login=${encodeURIComponent(login)}&password=${encodeURIComponent(password)}`
    });
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const data = await response.json();
    console.log('Login response:', data);
    
    if (data.success) {
      // Redirect on successful login
      if (data.redirect) {
        window.location.href = data.redirect;  // Redirect to specified URL
      } else {
        window.location.href = 'index.cgi';  // Default redirect
      }
      return;
    } else {
      // Show error message
      const errorMsg = data.error || 'Invalid username or password';
      if (errorElement) {
        errorElement.textContent = errorMsg;
        errorElement.style.display = 'block';
      } else {
        alert(errorMsg);
      }
    }
  } catch (error) {
    console.error('Login error:', error);
    console.error('Error details:', {
      name: error.name,
      message: error.message,
      stack: error.stack
    });
    if (errorElement) {
      errorElement.textContent = 'Login failed. Please try again.';
      errorElement.style.display = 'block';
    } else {
      alert('Login failed. Please try again.');
    }
  } finally {
    // Re-enable submit button
    if (submitButton) {
      submitButton.disabled = false;
      submitButton.textContent = 'Login';
    }
  }
  
  return false; // Prevent form submission
};
