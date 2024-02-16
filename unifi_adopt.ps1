# Überprüfung, ob das Posh-SSH Modul installiert ist
if (-not (Get-Module -ListAvailable -Name Posh-SSH)) {
    Write-Host "Posh-SSH Modul ist nicht installiert. Installation wird gestartet..."
    Install-Module -Name Posh-SSH -Repository PSGallery -Force
    Import-Module Posh-SSH
    Write-Host "Posh-SSH Modul wurde erfolgreich installiert."
} else {
    Write-Host "Posh-SSH Modul ist bereits installiert."
    Import-Module Posh-SSH
}

# Import des benötigten .NET Assemblies für die GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Initialisierung der Windows Forms Komponenten
$form = New-Object System.Windows.Forms.Form
$urlTextBox = New-Object System.Windows.Forms.TextBox
$textBox = New-Object System.Windows.Forms.TextBox
$button = New-Object System.Windows.Forms.Button
$urlLabel = New-Object System.Windows.Forms.Label
$label = New-Object System.Windows.Forms.Label
$outputBox = New-Object System.Windows.Forms.TextBox

# Konfiguration des Hauptfensters
$form.Text = 'SSH-Verbindungstool'
$form.Size = New-Object System.Drawing.Size(400, 350) # Größe angepasst für zusätzliches Feld
$form.StartPosition = 'CenterScreen'

# Konfiguration des URL Labels
$urlLabel.Location = New-Object System.Drawing.Point(10, 20)
$urlLabel.Size = New-Object System.Drawing.Size(380, 20)
$urlLabel.Text = 'Bitte geben Sie die URL ein:'
$form.Controls.Add($urlLabel)

# Konfiguration des URL Eingabefelds
$urlTextBox.Location = New-Object System.Drawing.Point(10, 40)
$urlTextBox.Size = New-Object System.Drawing.Size(360, 20)
$form.Controls.Add($urlTextBox)

# Konfiguration des Labels für die IPv4-Adresse
$label.Location = New-Object System.Drawing.Point(10, 70)
$label.Size = New-Object System.Drawing.Size(280, 20)
$label.Text = 'Bitte geben Sie die IPv4-Adresse ein:'
$form.Controls.Add($label)

# Konfiguration des Eingabefelds für die IPv4-Adresse
$textBox.Location = New-Object System.Drawing.Point(10, 100)
$textBox.Size = New-Object System.Drawing.Size(360, 20)
$form.Controls.Add($textBox)

# Konfiguration der Schaltfläche
$button.Location = New-Object System.Drawing.Point(10, 130)
$button.Size = New-Object System.Drawing.Size(360, 30)
$button.Text = 'Verbinden und Befehl ausführen'
$form.Controls.Add($button)

# Konfiguration der Ausgabebox
$outputBox.Location = New-Object System.Drawing.Point(10, 170)
$outputBox.Size = New-Object System.Drawing.Size(360, 130)
$outputBox.Multiline = $true
$outputBox.ScrollBars = 'Vertical'
$form.Controls.Add($outputBox)

# Aktion für den Button-Klick
$button.Add_Click({
    # Verbindungsdaten
    $deviceAddress = $textBox.Text
    $urlInform = $urlTextBox.Text
    $username = "ubnt"
    $password = "ubnt"

    # Umwandlung des Passworts in ein SecureString Objekt
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    $creds = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

    try {
        # Aufbau der SSH-Verbindung
        $Session = New-SSHSession -ComputerName $deviceAddress -Credential $creds -AcceptKey -ErrorAction Stop
        if ($Session.Connected) {
            # Ausführung des Befehls
            $command = "/bin/ash -c 'mca-cli-op set-inform $urlInform'"
            $response = Invoke-SSHCommand -SSHSession $Session -Command $command

            # Ausgabe und Bestätigung im Ausgabefeld
            $outputBox.Text = "Befehlsausgabe: $($response.Output)`r`nAdoption Complete"
        }
    } catch {
        $outputBox.Text = "Fehler bei der Verbindung oder Ausführung: $_"
    } finally {
        # Schließen der SSH-Sitzung, falls geöffnet
        if ($Session -and $Session.Connected) {
            Remove-SSHSession -SessionId $Session.SessionId
        }
    }
})

# Anzeigen des GUI-Fensters
$form.ShowDialog()
