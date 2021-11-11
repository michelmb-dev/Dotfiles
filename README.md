# À Propos

Dépot de secours en cas de formatage ou de configuration d'un nouvel environnement de travail qui me sert de sauvegarde et de mémo concernant la configuration mon installation de Linux.

- Désactivation du haut-parleur PC dans le noyau:
  
    ```console
    sudo echo "blacklist pcspkr" > /etc/modprobe.d/SpeakerNoBeep.conf
    ```

- Supprimer le Tearing sur Amd GPU:

    ```console
    sudo echo -e  "Section \"Device\" \n     Identifier \"AMD\" \n     Driver \"amdgpu\" \n     Option \"TearFree\" \"true\" \nEndSection" > /etc/X11/xorg.conf.d/20.amdgpu.conf
    ```
