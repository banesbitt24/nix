{ config, pkgs, ... }:

{
  # Lazydocker configuration with Nord theme
  xdg.configFile."lazydocker/config.yml".text = ''
    gui:
      scrollHeight: 2
      scrollPastBottom: true
      sidePanelWidth: 0.3333
      expandFocusedSidePanel: false
      screenMode: "normal"
      theme:
        activeBorderColor:
          - "#5e81ac"
          - bold
        inactiveBorderColor:
          - "#4c566a"
        selectedLineBgColor:
          - "#5e81ac"
        optionsTextColor:
          - "#88c0d0"
        selectedRangeBgColor:
          - "#5e81ac"
        cherryPickedCommitBgColor:
          - "#a3be8c"
        cherryPickedCommitFgColor:
          - "#2e3440"
        unstagedChangesColor:
          - "#d08770"
        defaultFgColor:
          - "#eceff4"
    logs:
      timestamps: false
      since: "60m"
      tail: "300"
    commandTemplates:
      restartService: "docker restart {{ .Service.Name }}"
      stopService: "docker stop {{ .Service.Name }}"
      serviceLogs: "docker logs --since=60m --follow --tail=300 {{ .Service.Name }}"
      viewServiceLogs: "docker logs --since=60m --follow --tail=300 {{ .Service.Name }}"
      rebuildService: "docker-compose up -d --build {{ .Service.Name }}"
      recreateService: "docker-compose up -d --force-recreate {{ .Service.Name }}"
      allLogs: "docker-compose logs --since=60m --follow --tail=300"
      viewAlLogs: "docker-compose logs --since=60m --follow --tail=300"
      dockerComposeConfig: "docker-compose config"
      checkDockerComposeConfig: "docker-compose config"
      serviceTop: "docker exec {{ .Service.Name }} top"
    oS:
      editCommand: "helix"
      editCommandTemplate: "helix {{ .Filename }}"
      openCommand: "xdg-open {{ .Filename }}"
      openLinkCommand: "xdg-open {{ .Link }}"
    stats:
      graphs:
        - caption: "CPU (%)"
          statPath: "DerivedStats.CPUPercentage"
          color: "#88c0d0"
        - caption: "Memory (%)"
          statPath: "DerivedStats.MemoryPercentage"  
          color: "#a3be8c"
    confirmOnQuit: false
    reporting: "off"
  '';
}