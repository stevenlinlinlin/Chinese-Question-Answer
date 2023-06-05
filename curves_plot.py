import numpy as np
import matplotlib.pyplot as plt
import sys
import json

with open(sys.argv[1], 'r') as f:
    data = json.load(f)

log_history = data['log_history']

# loss curves
#plt.subplot(1, 2, 1)
loss_x = [step['step'] for step in log_history if 'loss' in step.keys()]
loss_y = [step['loss'] for step in log_history if 'loss' in step.keys()]

plt.plot(loss_x, loss_y)

plt.title("roberta large loss")
plt.ylabel("loss")
plt.xlabel("step")

plt.show()
# EM curves
#plt.subplot(1, 2, 2)


plt.savefig('curves_plot_loss.png')