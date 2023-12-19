# Cluster Coyote
* co1 (manager) [slice=A] [hasconf] [persistent] [autoscale]
* co2 [slice=A] (later:[persistent]) [autoscale] [t_fsbpu]
* co3 (mc) [slice=B] [t_mchost]
* co4 [slice=B] [autoscale]

Each slice is sharing a gluster file system
