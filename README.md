# À Propos

Dépot de secours en cas de formatage ou de configuration d'un nouvel environnement de travail qui me sert de sauvegarde et de mémo concernant la configuration mon installation de Linux.

----------

# Mémo de configuration

1. Désactivation du haut-parleur PC dans le noyau:
  
    ```console
    sudo echo "blacklist pcspkr" > /etc/modprobe.d/SpeakerNoBeep.conf
    ```

2. Supprimer le Tearing sur Amd GPU:

    ```console
    sudo echo -e  "Section \"Device\" \n     Identifier \"AMD\" \n     Driver \"amdgpu\" \n     Option \"TearFree\" \"true\" \nEndSection" > /etc/X11/xorg.conf.d/20.amdgpu.conf
    ```

3. Ajouter autologin à lightdm pour dévérouillage keyring:

    - éditer le fichier "/etc/lightdm/lightdm.conf et activer les parametres pour PAM:

        ```console
        #...
        [Seat:*]
        #...
        pam-service=lightdm
        pam-autologin-service=lightdm-autologin
        pam-greeter-service=lightdm-greeter
        #...
        session-wrapper=/etc/lightdm/Xsession
        #...
        autologin-user=votre_utilisateur
        autologin-user-timeout=0
        #...
        ```

        > *Ne pas oublier de remplacer **"votre_utilisateur"** à la ligne **autologin-user** par le vrai nom d'utilisateur*

    - Vérifier l'existance du group autologin:

        ```console
        cat /etc/group | grep autologin
        ```

    - S'il n'existe pas, le créer et ajouter l'utilisateur à ce groupe :

        ```console
        groupadd -r autologin
        gpasswd -a votre_utilisateur autologin
        ```

        > *Ne pas oublier de remplacer **"votre_utilisateur"** sur la deuxième ligne par le vrai nom d'utilisateur*

    - S'il existe, vérifier que l'utilisateur appartienne à ce groupe :

        ```console
        groups
        ```

        Si oui, il n'y a rien à faire.

    - Sinon, il faut l'ajouter :

        ```console
        gpasswd -a votre_utilisateur autologin
        ```

        > *Ne pas oublier de remplacer **"votre_utilisateur"** par le vrai nom d'utilisateur*

4. Enregistrement de la disposition Multi écrans pour lightdm:

    - Pour la configuration, j'utilise l'utilitaire **Arandr** et j'exporte la configuration dans un fichier **configuration**.

    - Il faut activer le paramètre **"display-setup-script"** en y ajoutant le chemin vers le fichier **"screen-settings"**.

        ```console
        #...
        [Seat:*]
        #...
        display-setup-script=Chemin/screen-settings.sh
        #...
        ```

        > *Ne pas oublier de remplacer **"Chemin"** par le vrai emplacement du fichier*
