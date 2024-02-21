# UNIFI Adoption via SSH
Adopt UNIFI Devices via SSH to Controller

Das SSH-Verbindungstool ist ein PowerShell-Skript, das eine einfache grafische Benutzeroberfläche (GUI) bietet, um eine SSH-Verbindung zu einem Gerät herzustellen und spezifische Befehle auszuführen. Dieses Tool ermöglicht es Benutzern, die IPv4-Adresse und die URL für die `set-inform` Befehlsausführung über eine benutzerfreundliche Oberfläche einzugeben.

## Voraussetzungen

Um dieses Tool nutzen zu können, müssen folgende Voraussetzungen erfüllt sein:

- PowerShell 5.1 oder höher
- Installiertes Posh-SSH Modul

Das Skript prüft, ob das Posh-SSH Modul installiert ist, und installiert es bei Bedarf automatisch.
Die Anwendung muss beim ersten mal als Administrator ausgeführt werden um Posh-SSH Modul zu installieren.

Die Anwendung wurde mittels WIN-PS2EXE erstellt.
