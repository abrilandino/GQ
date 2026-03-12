import discord
import os

TOKEN = os.getenv("DISCORD_TOKEN")

TARGET_USERS = [
    718180397942571109,  # replace with first user ID cervantes
    606986226750455820,  # replace with second user ID ena
    540286026258710569 # user id 3 david
]

TEXT_CHANNEL_ID = 1253513612601851970  # replace with your text channel ID

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
        await message.channel.send(f"Se cree gran culo esa maje {message.author.mention}")

@client.event
async def on_voice_state_update(member, before, after):
    if member.id not in TARGET_USERS:
        return
    if before.channel is None and after.channel is not None:
        channel = client.get_channel(TEXT_CHANNEL_ID)
        if channel:
            await channel.send(f"Se cree gran culo esa maje {member.mention}")


client.run(TOKEN)
