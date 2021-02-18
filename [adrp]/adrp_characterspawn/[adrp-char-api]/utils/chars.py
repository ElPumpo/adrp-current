#!/usr/bin/env python
# -*- coding: utf-8 -*-

import MySQLdb, sys, os, random, string, requests, ast, json, time

def dbConnect(db='database'):
	db = MySQLdb.connect("localhost", "username", "password", db, charset='utf8')
	return db

def switchCharacter(identifier, networkID):
	db = dbConnect()
	cursor = db.cursor(MySQLdb.cursors.DictCursor)
	statement = "SELECT * FROM `characters` WHERE `networkID` = %s"
	cursor.execute(statement, [networkID])
	resp = cursor.fetchone()

	if resp['identifier'] != identifier:
		return {"success": False, "error": "This is not your character."}

	for key, value in resp.iteritems():
		if key == "characterID":
			key = "current_character"

		if key == "networkID":
			key = "current_network"

		if key != "vehicles" and key != "properties" and key != "licenses" and key != "dirtymoney" and key != "identifier" and key != "name" and key != "license":
			statement = "UPDATE users SET "+key+" = %s WHERE identifier = %s"
			cursor.execute(statement, [value, identifier])

	tables = ["vehicles", "properties", "licenses"]
	for table in tables:
		if resp[table] == None:
			resp[table] = {}
		else:
			resp[table] = json.loads(resp[table])

	# Vehicles
	statement = "UPDATE owned_vehicles SET owner = 'none' WHERE owner = %s"
	cursor.execute(statement, [identifier])
	for vehicle in resp["vehicles"]:
		statement = "UPDATE owned_vehicles SET owner = %s WHERE plate = %s"
		cursor.execute(statement, [identifier, vehicle['plate']])

	# Properties
	statement = "UPDATE owned_properties SET owner = 'none' WHERE owner = %s"
	cursor.execute(statement, [identifier])
	for property in resp["properties"]:
		statement = "UPDATE owned_properties SET owner = %s WHERE id = %s"
		cursor.execute(statement, [identifier, property['id']])

	# Licenses
	statement = "UPDATE user_licenses SET owner = 'none' WHERE owner = %s"
	cursor.execute(statement, [identifier])
	for license in resp["licenses"]:
		statement = "UPDATE user_licenses SET owner = %s WHERE id = %s"
		cursor.execute(statement, [identifier, license['id']])

	# Accounts
	statement = "UPDATE user_accounts SET money = %s WHERE identifier = %s AND name = 'black_money'"
	cursor.execute(statement, [resp["dirtymoney"], identifier])

	try:
		db.commit()
	except Exception as e:
		return {"success": False, "error": e}
	else:
		return {"success": True, "character": resp}


def saveCharacter(identifier, disconnect):
	millis = int(round(time.time() * 1000))
	db = dbConnect()
	cursor = db.cursor(MySQLdb.cursors.DictCursor)
	statement = "SELECT * FROM users WHERE identifier = %s"
	cursor.execute(statement, [identifier])
	resp = cursor.fetchone()

	if resp == None:
		print("User not found.")
		return {"success": False, "error": "User not found."}

	# Vehicle
	statement = "SELECT plate FROM owned_vehicles WHERE owner = %s"
	cursor.execute(statement, [identifier])
	resp["vehicles"] = json.dumps(cursor.fetchall())

	# Properties
	statement = "SELECT id FROM owned_properties WHERE owner = %s"
	cursor.execute(statement, [identifier])
	resp["properties"] = json.dumps(cursor.fetchall())

	# Licenses
	statement = "SELECT id FROM user_licenses WHERE owner = %s"
	cursor.execute(statement, [identifier])
	resp["licenses"] = json.dumps(cursor.fetchall())

	# Dirty money
	statement = "SELECT money FROM user_accounts WHERE identifier = %s AND name = 'black_money'"
	cursor.execute(statement, [identifier])

	dirtyObject = cursor.fetchone()

	if dirtyObject == None:
		resp["dirtymoney"] = 0
	else:
		resp["dirtymoney"] = dirtyObject['money']

	if disconnect:
		statement = "UPDATE users SET current_character = -1, current_network = -1 WHERE identifier = %s"
		cursor.execute(statement, [identifier])

	millis2 = int(round(time.time() * 1000))
	res = millis2 - millis

	print('It took {0} ms to get {1}'.format(str(res), identifier))

	millis = int(round(time.time() * 1000))

	for key, value in resp.iteritems():
		if key == "current_character":
			key = "characterID"

		if key != "group" and key != "permission_level" and key != "startup_money" and key != "identifier" and key != "name" and key != "license" and key != "current_network" and key != "characterID":
			statement = "UPDATE characters SET "+key+" = %s WHERE networkID = %s"
			cursor.execute(statement, [value, resp["current_network"]])

	millis2 = int(round(time.time() * 1000))
	res = millis2 - millis
	print('It took {0} ms to write {1}'.format(str(res), identifier))

	try:
		db.commit()
	except Exception as e:
		return {"success": False, "error": e}
	else:
		return {"success": True}


def saveUnsavedPlayers():
	db = dbConnect()
	cursor = db.cursor(MySQLdb.cursors.DictCursor)
	statement = "SELECT identifier FROM users WHERE NOT current_network = -1"
	cursor.execute(statement)
	users = cursor.fetchall()

	for user in users:
		time.sleep(1)
		identifier = user['identifier']

		print('Saving {} ...'.format(identifier))
		resp = saveCharacter(identifier, True)

		if resp['success'] == False:
			print('Failed saving {}'.format(identifier))
		else:
			print('Success saving {}'.format(identifier))

	return {"success": True}
