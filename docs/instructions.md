# Instructions for LNDg

You can login using the username "lndg-admin"
Your admin password can be found on the properties page.

# Detailed instructions and suggested steps from LNDg support

## LNDg First Steps
1 - Enable the channels that you want to get outbound liquidity to

2 - For each enabled channel enter the inbound % that you want to push that channel down to. For example, if you want 90% on the local side of a channel then enter 10% in the iTarget%. You must hit enter after you type in the number for the change to become effective.

3 - The enabled channels will attempt to fill the local / outbound side by using the non-enabled channels to rebalance. So an Enabled channel will not be used to rebalance other enabled channels; this is important to understand.

4 - If you have a channel that you aren’t trying to push outbound towards but you don’t want it to be used to rebalance the enabled channels either then set iTarget% to 100%. As it is enabled it won’t be used to rebalance other channels and as you are trying to achieve 100% on the inbound side it won’t push any sats to the outbound side, therefore effectively allowing the channel to be ignored by the rebalancer.

## Settings
Enabled - needs to be set to 1 for the rebalancing attempts to be switched on

Target Amount % - is the percentage of each channel that you attempt to rebalance in a single attempt

Target Time - how long the rebalancing attempt should run for. Recommended in the range of 3 – 5 minutes

Target Outbound Above % - determines whether a non-enabled channel will be attempted to rebalance the enabled channels by reference to the current split of inbound / outbound liquidity.  For example, if this is set at 50% it will try to use a non-enabled channel that has more than 50% outbound to rebalance the enabled channels. It will not try to use channels that have less than 50% outbound.

Global Max Fee Rate – This is the max fee rate in ppm that you want to pay to rebalance

Max Cost % - This is the max % of your fees that you want to charge. If you charge 500ppm on the channel and the Max Cost % is 80% it will try to rebalance the channel so long as the cost is no more than 400ppm. Note that both the Max Fee Rate and Max Cost % will limit the amount that will be paid to rebalance.

Autopilot – Keep it set at 0. Do not enable Autopilot until you become more experienced with how this works!!