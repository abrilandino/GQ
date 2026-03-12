import discord
import os
import asyncio
from aiohttp import web

TOKEN = os.getenv("DISCORD_TOKEN")

TARGET_USERS = [
    718180397942571109,  # cervantes
    606986226750455820,  # ena
    540286026258710569,  # david
    709522241230078002   # user id 4
]

TEXT_CHANNEL_ID = 1253513612601851970

intents = discord.Intents.default()
intents.message_content = True
intents.voice_states = True
intents.members = True

client = discord.Client(intents=intents)

@client.event
async def on_ready():
    print(f"Logged in as {client.user}")

@client.event
async def on_message(message):
    if message.author.bot:
        return
    if message.author.id in TARGET_USERS:
        channel = client.get_channel(TEXT_CHANNEL_ID)
        if channel:
            await channel.send(f"Se cree gran culo esa maje {message.author.mention}")

@client.event
async def on_voice_state_update(member, before, after):
    if member.id not in TARGET_USERS:
        return
    if before.channel is None and after.channel is not None:
        channel = client.get_channel(TEXT_CHANNEL_ID)
        if channel:
            await channel.send(f"Se cree gran culo esa maje {member.mention}")

async def health(request):
    return web.Response(text="OK")

async def start_web():
    app = web.Application()
    app.router.add_get("/", health)
    runner = web.AppRunner(app)
    await runner.setup()
    site = web.TCPSite(runner, "0.0.0.0", 8000)
    await site.start()

async def main():
    await start_web()
    await client.start(TOKEN)

asyncio.run(main())
