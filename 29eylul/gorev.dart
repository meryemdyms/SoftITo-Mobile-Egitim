void main(){
  final bool isProduction = true;

  final Set<String> cloudServices = {
  "auth-service",
  "payment-service",
  "notification-service",
  "user-service",
};

  final List<String> tumServisler = [
    ...cloudServices,
    if (isProduction) "vault-secret-manager",
  ];

  for(int i=0; i<tumServisler.length;i++){
    print("Servis ${i+1}: ${tumServisler[i]}");
  }

}