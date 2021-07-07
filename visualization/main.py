from diagrams import Cluster, Diagram
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.onprem.network import Traefik
from diagrams.gcp.compute import AppEngine
from diagrams.generic.compute import Rack
from diagrams.generic.device import Mobile
from diagrams.custom import Custom

with Diagram("infrastructure", show=False):
    with Cluster("Docker Swarm"):
        traefik = Traefik("Reverse Proxy\n(Traefik)")
        prometheus = Prometheus("Metrics\n(Prometheus)")
        grafana = Grafana("Data Viz\n(Grafana)")
        swarmpit = AppEngine("Swarm Manager\n(Swarmpit)")

        with Cluster("Microservices"):
            thumbnailer = Rack("Thumbnailer")
            lumberer = Rack("Lumberer (Logs)")

        with Cluster("Applications"):
            manager = Rack("FreeStuff Manager")
            otherBots = Rack("Other Bots\n(Greenlight,\nTudeBot, ...)")

        with Cluster("FreeStuff Bot"):
            bot1 = Rack("ShardCluster1")
            bot2 = Rack("ShardCluster2")
            bot3 = Rack("ShardCluster3")

    internet = Mobile("Internet / API")
    discord = Custom("Discord", "./Discord-Logo-Color.png")

    traefik << prometheus << grafana
    [thumbnailer, lumberer, manager, otherBots] << prometheus
    [bot1, bot2, bot3] << prometheus
    [bot1, bot2, bot3] >> discord
    traefik >> [thumbnailer, lumberer, manager]
    internet >> traefik