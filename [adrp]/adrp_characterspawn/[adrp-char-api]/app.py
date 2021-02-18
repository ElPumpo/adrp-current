#!/usr/bin/env python
# -*- coding: utf-8 -*-

from flask import *
import os, time, random, json, socket
from utils.chars import saveCharacter, switchCharacter, saveUnsavedPlayers
app = Flask(__name__)
app.secret_key = os.urandom(24)

@app.route('/save/<identifier>/<disconnect>')
def save(identifier, disconnect):
	if disconnect == 'false':
		disconnect = False
	elif disconnect == 'true':
		disconnect = True

	print('Saving {} ...'.format(identifier))
	millis = int(round(time.time() * 1000))
	resp = saveCharacter(identifier, disconnect)
	millis2 = int(round(time.time() * 1000))
	res = millis2 - millis

	if resp['success']:
		resp['time'] = str(res) + ' ms'
		print("Saved " + identifier)
	else:
		print("Error saving " + identifier)

	return jsonify(resp)


@app.route("/switch/<identifier>/<networkID>")
def switch(identifier, networkID):
	networkID = int(networkID)
	millis = int(round(time.time() * 1000))
	resp = switchCharacter(identifier, networkID)
	millis2 = int(round(time.time() * 1000))
	res = millis2 - millis
	resp['time'] = str(res) + ' ms'

	return jsonify(resp)


@app.route('/saveUnsaved')
def saveUnsaved():
	millis = int(round(time.time() * 1000))
	resp = saveUnsavedPlayers()
	millis2 = int(round(time.time() * 1000))
	res = millis2 - millis
	resp['time'] = str(res) + ' ms'

	return jsonify(resp)


if __name__ == "__main__":
	app.run(host="localhost", port=5004, threaded=True)
