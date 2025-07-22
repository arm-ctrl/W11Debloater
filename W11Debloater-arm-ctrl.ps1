# W11Debloater-arm-ctrl.ps1
# Script de nettoyage et configuration initiale pour Windows 10/11
# Par arm-ctrl

# --- Liste des bloatwares à désinstaller ---
$bloatwareApps = @(
    # Réseaux sociaux et messageries
    'Microsoft.LinkedIn',
    'Facebook.Facebook',
    'FACEBOOK.317180B0BB486',
    'WhatsApp.WhatsApp',
    'WhatsAppDesktop_8xx8rvfyw5nnt',
    'TikTok.TikTok',
    'Instagram.Instagram',
    'Messenger.Messenger',
    # Xbox (toutes variantes)
    'Microsoft.XboxApp',
    'Microsoft.XboxGamingOverlay',
    'Microsoft.XboxGameCallableUI',
    'Microsoft.XboxSpeechToTextOverlay',
    'Microsoft.Xbox.TCUI',
    'Microsoft.XboxGameOverlay',
    'Microsoft.XboxIdentityProvider',
    'Microsoft.XboxLive',
    'Microsoft.XboxLiveGames',
    # Bing
    'Microsoft.BingFinance',
    'Microsoft.BingNews',
    'Microsoft.BingSports',
    'Microsoft.BingWeather',
    'Microsoft.BingFoodAndDrink',
    'Microsoft.BingTravel',
    'Microsoft.BingHealthAndFitness',
    # Clipchamp
    'Microsoft.Clipchamp',
    # WebAdvisor by McAfee (nom du package peut varier, on cible générique)
    'McAfee.WebAdvisor',
    'WebAdvisor',
    # Autres bloatwares courants
    'Microsoft.3DBuilder',
    'Microsoft.3DViewer',
    'Microsoft.GetHelp',
    'Microsoft.Getstarted',
    'Microsoft.Microsoft3DViewer',
    'Microsoft.MicrosoftOfficeHub',
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.MicrosoftStickyNotes',
    'Microsoft.MixedReality.Portal',
    'Microsoft.MSPaint',
    'Microsoft.Office.OneNote',
    'Microsoft.OneConnect',
    'Microsoft.People',
    'Microsoft.SkypeApp',
    'Microsoft.Wallet',
    'Microsoft.WindowsAlarms',
    'Microsoft.WindowsCamera',
    'Microsoft.windowscommunicationsapps',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.WindowsMaps',
    'Microsoft.WindowsSoundRecorder',
    'Microsoft.YourPhone',
    'Microsoft.ZuneMusic',
    'Microsoft.ZuneVideo',
    'Microsoft.GrooveMusic',
    'Microsoft.MoviesAndTV',
    'Microsoft.Cortana',
    'Microsoft.Paint3D',
    'Microsoft.News',
    'Microsoft.Weather',
    'Microsoft.Todos',
    'Microsoft.Whiteboard',
    'Microsoft.PowerAutomateDesktop',
    'Microsoft.OutlookForWindows'
)

Write-Host "\n--- Désinstallation des applications inutiles (pour tous les utilisateurs et futurs comptes) ---\n"

foreach ($app in $bloatwareApps) {
    $found = $false
    # Désinstallation pour tous les utilisateurs existants
    $pkgs = Get-AppxPackage -AllUsers | Where-Object { $_.Name -eq $app }
    if ($pkgs) {
        foreach ($pkg in $pkgs) {
            try {
                Write-Host "Suppression de $($pkg.Name) pour l'utilisateur $($pkg.InstallLocation)..."
                Remove-AppxPackage -Package $pkg.PackageFullName -AllUsers -ErrorAction Stop
                $found = $true
            } catch {
                Write-Host "Impossible de supprimer $($pkg.Name) : $_.Exception.Message (probablement une app système non désinstallable)"
            }
        }
    }
    # Désinstallation des apps provisionnées (pour les futurs comptes)
    $provPkgs = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq $app }
    if ($provPkgs) {
        foreach ($prov in $provPkgs) {
            try {
                Write-Host "Suppression du package provisionné $($prov.DisplayName)..."
                Remove-AppxProvisionedPackage -Online -PackageName $prov.PackageName -ErrorAction Stop
                $found = $true
            } catch {
                Write-Host "Impossible de supprimer le package provisionné $($prov.DisplayName) : $_.Exception.Message"
            }
        }
    }
    if (-not $found) {
        Write-Host "$app non trouvé ou non désinstallable."
    }
}

# --- Recherche et installation des mises à jour Windows ---
Write-Host "\n--- Recherche et installation des mises à jour Windows ---\n"
Install-Module -Name PSWindowsUpdate -Force -Confirm:$false -Scope CurrentUser
Import-Module PSWindowsUpdate
Get-WindowsUpdate -AcceptAll -Install -AutoReboot:$false

# --- Aligner la barre des tâches à gauche (Windows 11) ---
Write-Host "\n--- Alignement de la barre des tâches à gauche ---\n"
try {
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    Set-ItemProperty -Path $regPath -Name TaskbarAl -Value 0
    Write-Host "Barre des tâches alignée à gauche."
} catch {
    Write-Host "Impossible de modifier l'alignement de la barre des tâches. Peut-être non supporté sur cette version."
}

# --- Désactiver Vue tâches et Widgets dans la barre des tâches (Windows 11) ---
Write-Host "\n--- Désactivation de Vue tâches et Widgets dans la barre des tâches ---\n"
try {
    # Désactiver Vue tâches
    Set-ItemProperty -Path $regPath -Name ShowTaskViewButton -Value 0
    # Désactiver Widgets (Windows 11)
    Set-ItemProperty -Path $regPath -Name TaskbarDa -Value 0
    Write-Host "Vue tâches & Widgets désactivés dans la barre des tâches."
} catch {
    Write-Host "Impossible de désactiver Vue tâches & Widgets. Peut-être non supporté sur cette version."
}

# --- Désactiver la recherche Bing dans le menu démarrer ---
Write-Host "\n--- Désactivation de la recherche Bing dans le menu démarrer ---\n"
try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0
    Write-Host "Clé de registre BingSearchEnabled=0 ajoutée."
} catch {
    Write-Host "Impossible de modifier BingSearchEnabled : $_"
}

# --- Désactiver la gestion automatique de l'imprimante par défaut ---
Write-Host "\n--- Désactivation de la gestion auto de l'imprimante par défaut ---\n"
try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name "LegacyDefaultPrinterMode" -Type DWord -Value 1
    Write-Host "Option 'Laisser Windows gérer mon imprimante par défaut' décochée."
} catch {
    Write-Host "Impossible de modifier la gestion auto de l'imprimante par défaut : $_"
}

# --- Activer l'historique du presse-papiers (Win+V) ---
Write-Host "\n--- Activation de l'historique du presse-papiers ---\n"
try {
    $clipboardKey = "HKCU:\Software\Microsoft\Clipboard"
    if (-not (Test-Path $clipboardKey)) { New-Item -Path $clipboardKey -Force | Out-Null }
    Set-ItemProperty -Path $clipboardKey -Name "EnableClipboardHistory" -Type DWord -Value 1
    Write-Host "Historique du presse-papiers (Win+V) activé."
} catch {
    Write-Host "Impossible d'activer l'historique du presse-papiers : $_"
}

# --- Activer le pavé numérique au démarrage ---
Write-Host "\n--- Activation du pavé numérique au démarrage ---\n"
try {
    $kbdKey = "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard"
    Set-ItemProperty -Path $kbdKey -Name "InitialKeyboardIndicators" -Value "2"
    Write-Host "Pavé numérique activé au démarrage (InitialKeyboardIndicators=2)."
} catch {
    Write-Host "Impossible d'activer le pavé numérique au démarrage : $_"
}

# --- Personnalisation du menu Démarrer : recommandations ---
Write-Host "\n--- Personnalisation du menu Démarrer : recommandations ---\n"
try {
    # Forcer la télémétrie minimale (sinon l'option reste grisée)
    $telemetryKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (Test-Path $telemetryKey) {
        Set-ItemProperty -Path $telemetryKey -Name "AllowTelemetry" -Type DWord -Value 1
        Write-Host "Télémétrie minimale activée (AllowTelemetry=1)."
    }
    # Supprimer ou désactiver HideRecentlyUsedApps (empêche l'affichage des applis les plus utilisées)
    $hideAppsKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
    if (Test-Path $hideAppsKey) {
        Remove-ItemProperty -Path $hideAppsKey -Name "HideRecentlyUsedApps" -ErrorAction SilentlyContinue
        Write-Host "Clé HideRecentlyUsedApps supprimée."
    }
    # Désactiver les recommandations dans le menu Démarrer (Windows 11)
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_IrisRecommendations" -Type DWord -Value 0
    Write-Host "Recommandations désactivées dans le menu Démarrer."
} catch {
    Write-Host "Impossible de personnaliser le menu Démarrer : $_"
}

# --- Désactivation du Bluetooth ---
Write-Host "\n--- Désactivation du Bluetooth ---\n"
try {
    $bt = Get-PnpDevice | Where-Object { $_.Class -eq 'Bluetooth' -and $_.Status -eq 'OK' }
    if ($bt) {
        $bt | Disable-PnpDevice -Confirm:$false
        Write-Host "Bluetooth désactivé."
    } else {
        Write-Host "Aucun adaptateur Bluetooth actif trouvé."
    }
} catch {
    Write-Host "Erreur lors de la désactivation du Bluetooth : $_"
}

# --- Renommage du PC via boîte de dialogue ---
Add-Type -AssemblyName Microsoft.VisualBasic
$pcName = [Microsoft.VisualBasic.Interaction]::InputBox("Nouveau nom du PC :", "Renommer le PC", $env:COMPUTERNAME)
if ($pcName -and $pcName -ne $env:COMPUTERNAME) {
    try {
        Rename-Computer -NewName $pcName -Force
        Write-Host "Nom du PC changé en $pcName."
    } catch {
        Write-Host "Erreur lors du renommage : $_"
    }
} else {
    Write-Host "Renommage annulé ou identique."
}

# --- Création d'un point de restauration système ---
Write-Host "\n--- Création d'un point de restauration système ---\n"
try {
    $date = Get-Date -Format "dd-MM-yyyy_HH-mm"
    Checkpoint-Computer -Description "W11Debloater_$date" -RestorePointType 'MODIFY_SETTINGS'
    Write-Host "Point de restauration créé : W11Debloater_$date"
} catch {
    Write-Host "Erreur lors de la création du point de restauration : $_"
}

# --- Gestion des favoris Microsoft Edge ---
Write-Host "\n--- Nettoyage des favoris Edge et ajout de Google.fr ---\n"

try {
    $edgeProfile = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default"
    $bookmarksPath = Join-Path $edgeProfile 'Bookmarks'

    # Fermer Edge si ouvert
    $edgeProc = Get-Process msedge -ErrorAction SilentlyContinue
    if ($edgeProc) {
        Write-Host "Fermeture de Microsoft Edge..."
        Stop-Process -Name msedge -Force
        Start-Sleep -Seconds 2
    }

    # Vider la barre de favoris et ajouter Google.fr
    if (Test-Path $bookmarksPath) {
        $bookmarks = Get-Content $bookmarksPath -Raw | ConvertFrom-Json
        $bookmarks.roots.bookmark_bar.children = @()
        $googleFav = @{type="url"; name="Google"; url="https://google.fr"; guid=[guid]::NewGuid().ToString()}
        $bookmarks.roots.bookmark_bar.children += $googleFav
        $bookmarks | ConvertTo-Json -Depth 10 | Set-Content -Path $bookmarksPath -Encoding UTF8
        Write-Host "Barre de favoris vidée et Google.fr ajouté."
    } else {
        Write-Host "Fichier Bookmarks introuvable, favoris non modifiés. Lance Edge une fois pour initialiser le profil."
    }

} catch {
    Write-Host "Erreur lors de la gestion des favoris Edge : $_"
}

# --- Proposition de redémarrage ---
Add-Type -AssemblyName PresentationFramework
$result = [System.Windows.MessageBox]::Show("Redémarrer maintenant pour appliquer les modifications ?", "Redémarrage", 'YesNo', 'Question')
if ($result -eq 'Yes') {
    Restart-Computer -Force
} else {
    Write-Host "Redémarrage annulé. Pensez à redémarrer manuellement pour appliquer tous les changements."
}