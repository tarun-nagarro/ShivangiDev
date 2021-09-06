public class SendAccountUsingRESTAPI {
  private final String clientId = '3MVG9Y6d_Btp4xp5PXQfFFbPeJQihk89GrEwQlqxlE6UEynxFXwW4Gy_N8g1T5ooAgXWF3P6Jbci.0wLOtwNe';
   private final String clientSecret = '2181120660800988790';
   private final String username = 'ashok.sdangi@gmail.com';
   private final String password = 'Dell$01234567890stqlD3tELLtoHO4tovL3GCOK';
  public class deserializeResponse
   {
      public String id;
      public String access_token;
   }
  public String ReturnAccessToken (SendAccountUsingRESTAPI acount)
   {
      String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
      Http h = new Http();
      HttpRequest req = new HttpRequest();
      req.setBody(reqbody);
      req.setMethod('POST');
      req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
      HttpResponse res = h.send(req);
     deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);
     system.debug('@@@@access_token@@'+resp1 );
      return resp1.access_token;
   }
     
   public static list<Account> callgetaccact (String AccountNumber)
   {
           SendAccountUsingRESTAPI acount1 = new SendAccountUsingRESTAPI();
           String accessToken;
           accessToken = acount1.ReturnAccessToken (acount1);
           list<Account> Lstaccact=new List<Account>();
           if(accessToken != null){
           String endPoint = 'https://ashokdangi-dev-ed.my.salesforce.com/services/apexrest/bootstrap_dev/ShowAccounts/' +AccountNumber;
           //String jsonstr = '{"AccountNumber" : "' + AccountNumber+ '"}';
           Http h2 = new Http();
           HttpRequest req1 = new HttpRequest();
           req1.setHeader('Authorization','OAuth ' + accessToken);
           req1.setHeader('accent-Type','application/json');
           req1.setHeader('accept','application/json');
           //req1.setBody(jsonstr);
           req1.setMethod('GET');
           req1.setEndpoint(endPoint);
           HttpResponse res1 = h2.send(req1);
           String trimmedResponse = res1.getBody().unescapeCsv().remove('\\');
           system.debug('@@@RESPONSE@@'+trimmedResponse);
           JSONParser parser = JSON.createParser(res1.getBody());
           set<Account> accList=new set<Account>();
            
            while (parser.nextToken() != null) {
                //Id
                
                if((parser.getCurrentToken() == JSONToken.FIELD_NAME) ){
                    Account acc;
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Id')) {
                    // Get the value.
                    parser.nextToken();
                    // Compute the grand total price for all invoices.
                    string sId= parser.getText();
                    acc=new Account();
                    //acc.Id=sId;
                    system.debug('Id@@@' + sId);
                    
                    parser.nextToken();
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() == 'Name')) {
                        // Get the value.
                        parser.nextToken();
                        // Compute the grand total price for all invoices.
                        string sName= parser.getText();
                        acc.Name=sName;
                        system.debug('Name@@@' + sName );
                    }
                    
                    //Email
                    
                
                }
                accList.add(acc); 
                }
                
                
                
                accList.remove(null);
                
            }
            Lstaccact.AddAll(accList);
            insert Lstaccact;
            system.debug('accList@@@@'+Json.serialize(Lstaccact));
            
            
           
        
        }
        return Lstaccact;
   }
   
}