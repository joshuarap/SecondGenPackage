@RestResource(urlMapping='/insertAccounts')
global with sharing class AccountsWrapper {
    public List<AccountWrapper> Accounts;

    public class AccountWrapper {
        public String Name;
        public string Industry;
    }

    @HttpPost
    global static void insertAccounts() {
        try {
            // Read JSON from the request body
            RestRequest req = RestContext.request;
            String jsonString = req.requestBody.toString();

            // Deserialize JSON into Wrapper Class
            AccountsWrapper wrapper = 
                (AccountsWrapper) JSON.deserialize(jsonString, AccountsWrapper.class);

            if (wrapper != null && wrapper.Accounts != null && !wrapper.Accounts.isEmpty()) {
                List<Account> accountList = new List<Account>();

                for (AccountWrapper accWrapper : wrapper.Accounts) {
                    if (accWrapper.Name != null) {
                        accountList.add(new Account(Name = accWrapper.Name));
                        System.debug('Line26: ' + accWrapper.Industry);
                    }
                }

                if (!accountList.isEmpty()) {
                    //insert accountList;
                    //System.debug('Inserted Accounts: ' + accountList);
                }
            }
        } catch (Exception e) {
            System.debug('Error inserting accounts: ' + e.getMessage());
            RestContext.response.statusCode = 400; // Bad Request
            RestContext.response.responseBody = Blob.valueOf('Error: ' + e.getMessage());
        }
    }
}