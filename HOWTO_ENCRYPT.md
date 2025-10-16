# Encrypting with age (example)
# Generate a keypair once (keep private key OFF repo):
age-keygen -o $HOME\.age\id.txt
age-keygen -y $HOME\.age\id.txt > .secure\agekey.pub

# Encrypt:
age -R .secure\agekey.pub -o .secure/HP_plan.md.age HP_plan.md

# Decrypt (local only):
age -d -i $HOME\.age\id.txt -o HP_plan.md .secure/HP_plan.md.age
