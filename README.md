# cheap-travels
Progetto Laboratorio di Architetture Software e Sicurezza Informatica 2022
=======
<p>
<strong>--- Alessandro ---</strong><br>
Ho dovuto modificare la prima riga di:
<ol>
	<li><code>bin/rails</code></li>
	<li><code>bin/rake</code></li>
	<li><code>bin/setup</code></li>
</ol>
per far girare il tutto su Linux (faceva riferimento a file .exe). Se qualcuno usa Windows e riscontra problemi, basta rimodificarla aggiungende l'estensione al nome dell'eseguibile.<br><br>
Cosa ho fatto:
<ol>
	<li>ho aggiunto il controller per la home page per evitare l'errore</li>
	<li>ho implementato le basi dell'autenticazione con devise</li>
	<li>ho inserito una navbar provvisoria contenente alcuni link</li>
</ol>
<p>