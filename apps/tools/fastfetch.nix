{...}: {
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        source = "NixOS";
        type = "small";
      };

      display = {
        separator = " ";
      };

      modules = [
        {
          key = "╭───────────╮";
          type = "custom";
        }

        {
          key = "│ {#31} user    {#keys}│";
          type = "title";
          format = "{user-name}";
        }

        {
          key = "│ {#33}󰅐 uptime  {#keys}│";
          type = "uptime";
        }

        {
          key = "│ {#34}{icon} distro  {#keys}│";
          type = "os";
          format = "{id} {codename}";
        }

        {
          key = "│ {#35} wm      {#keys}│";
          type = "wm";
          format = "{pretty-name}";
        }

        {
          key = "│ {#37} term    {#keys}│";
          type = "terminal";
          format = "{pretty-name}";
        }

        {
          key = "│ {#32} shell   {#keys}│";
          type = "shell";
          format = "{pretty-name}";
        }

        {
          key = "│ {#33}󰏖 apps    {#keys}│";
          type = "packages";
        }

        {
          key = "│ {#36}󰉉 memory  {#keys}│";
          type = "memory";
          format = "{used} / {total}";
        }

        {
          key = "│ {#38} battery {#keys}│";
          type = "battery";
          format = "{capacity}% ({status})";
        }

        {
          key = "│ {#31} cpu     {#keys}│";
          type = "cpu";
        }

        {
          key = "│ {#35} temp    {#keys}│";
          type = "cpu-temp";
          format = "{temperature}";
        }

        {
          key = "│ {#34}󰢮 gpu     {#keys}│";
          type = "gpu";
          format = "{name} ({vendor})";
        }

        {
          key = "│ {#33}󰖩 bright  {#keys}│";
          type = "brightness";
          format = "{percentage}";
        }

        {
          key = "│ {#36}󰤨 wifi    {#keys}│";
          type = "network";
          format = "{interface}: {signal}%";
        }

        {
          key = "├───────────┤";
          type = "custom";
        }

        {
          key = "│ {#39} colors  {#keys}│";
          type = "colors";
          symbol = "circle";
        }

        {
          key = "╰───────────╯";
          type = "custom";
        }
      ];
    };
  };
}
