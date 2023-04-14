// A cada alteracao em qualquer uma das entradas, imprime uma string com formato
// J.V.D.d.b....B.... -> Jogar, Vitoria, Derrota, dificuldade, botoes, Buracos
// Obs: Existe um tempo minimo entre o envio de strings, para fazer debouncing 

const int jogarPin = 15;
const int vitoriaPin = 21;
const int derrotaPin = 19;
const int dificuldadePins[] = {2, 4};
const int buracosPins[] = {13, 12, 14, 27};
const int botoesPins[] = {16, 17, 5, 18};

String lastSent = "J.V.D.d.b....B....";
int lastTime = 0;
const int debounceTime = 20; // minimum time in between serial messages

void setup() {
  Serial.begin(115200);
  setupPins();
}

void loop() {
  String tempToSend = updateToSend();
  int now = millis();
  if ((tempToSend != lastSent) && (now - lastTime > debounceTime)) {
    Serial.println(tempToSend);
    lastSent = tempToSend;
    lastTime = now;
  }
}

String updateToSend() {
  String toSend = "J.V.D.d.b....B...."; // Jogar, Vitoria, Derrota, dificuldade, botoes, Buracos
  toSend[1] = digitalRead(jogarPin)? '1' : '0';
  toSend[3] = digitalRead(vitoriaPin)? '1' : '0';
  toSend[5] = digitalRead(derrotaPin)? '1' : '0'; 
  if (digitalRead(dificuldadePins[0])) toSend[7] = 'f';
  else if (digitalRead(dificuldadePins[1])) toSend[7] = 'd';
  else toSend[7] = 'n';
  for (int i=0; i < 4; i++) {
    toSend[9+i] = digitalRead(botoesPins[i]) ? '1' : '0';
    toSend[14+i] = digitalRead(buracosPins[i]) ? '1' : '0';
  }
  return toSend;
}

void setupPins() {
  pinMode(jogarPin, INPUT);
  pinMode(vitoriaPin, INPUT);
  pinMode(derrotaPin, INPUT);
  pinMode(dificuldadePins[0], INPUT);
  pinMode(dificuldadePins[1], INPUT);
  for (int i = 0; i < 4; i++) {
    pinMode(buracosPins[i], INPUT);
    pinMode(botoesPins[i], INPUT);
  }
}
