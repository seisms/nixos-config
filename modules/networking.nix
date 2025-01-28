{}:
{
    networking= {
        hostName = "nixos"; # Define your hostname.
        networkmanager.enable = true;
        hosts = {
            "192.168.1.11" = ["bigbox"];
            "192.168.1.13" = ["littlebox"];
        };

        # Enables wireless support via wpa_supplicant.
        # wireless.enable = true;  

        # Configure network proxy if necessary
        # proxy.default = "http://user:password@proxy:port/";
        # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    };
}
