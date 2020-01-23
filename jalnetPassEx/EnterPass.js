var MyExtensionJavaScriptClass = function() {};

MyExtensionJavaScriptClass.prototype = {
    
run: function(arguments) {
    // Pass the baseURI of the webpage to the extension.
    arguments.completionFunction({"URL": document.URL});
},
    
    // Note that the finalize function is only available in iOS.
finalize: function(arguments) {
    // arguments contains the value the extension provides in [NSExtensionContext completeRequestReturningItems:completion:].
    // In this example, the extension provides a color as a returning item.
    if (arguments["origPage"] == "BRIC") {
        document.getElementById('In_PersonnelID').value = arguments["userID"];
        document.getElementById('In_Password').value = arguments["password"];
        document.getElementById('Btn_CrewLogin').click();
    } else if (arguments["origPage"] == "Intranet") {
        document.forms[0].user.value = arguments["userID"];
        document.forms[0].pass.value = arguments["password"];
        document.getElementById('login').click();
    } else if (arguments["origPage"] == "Album") {
        document.forms['loginform'].txtAccountId.value = arguments["userID"];
        document.forms['loginform'].txtPassword.value = arguments["password"];
        document.forms['loginform'].btnLogin.click();
    } else if (arguments["origPage"] == "IntraDog") {
        document.forms[0].user.value = arguments["userID"];
        document.forms[0].pass.value = arguments["password"];
        document.forms[0].js.value = 'ok';
        document.forms[0].submit();
    } else if (arguments["origPage"] == "LoginTest") {
        document.forms[0].EnterID.value = arguments["userID"];
        document.forms[0].EnterPassWord.value = arguments["password"];
        document.forms[0].SubmitBtn.click();
    }
}

};

// The JavaScript file must contain a global object named "ExtensionPreprocessingJS".
var ExtensionPreprocessingJS = new MyExtensionJavaScriptClass;
