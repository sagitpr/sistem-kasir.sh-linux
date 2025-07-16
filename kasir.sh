#!/bin/bash
#kasir.sh

# Pastikan ini di jalankan dengan bash
if [ -z "$BASH_VERSION" ]; then
	echo "Error: This script requires bash. Please run with 'bash kasir.sh'"
	exit 1
fi

# Daftar menu dan harga
declare -A menu=(
	["1"]="Nasi Goreng|15000"
	["2"]="Mie Ayam|12000"
	["3"]="Sate Ayam|18000"
	["4"]="Teh Manis|5000"
	["5"]="Es Jeruk|6000"
)

# Fungsi untuk menampilkan menu
tampilkan_menu() {
	echo "========== Menu Warung Makan =========="
	for key in "${!menu[@]}"; do
		nama=${menu[$key]%%|*}
		harga=${menu[$key]#*|}
		printf "%d. %s ......... Rp%s\n" "$key" "$nama" "$harga"
	done
	echo "========================================"
}

# Array untuk menyimpan pesanan
declare -A pesanan
total_belanja=0

# Main program
echo "Selamat datang di Kasir Sederhana!!"
while true; do
	tampilkan_menu
	echo "Berapa jumlah item yang ingin di beli?"
	read jumlah_item
	# Validasi jumlah item
	if [ -z "${jumlah_item//[0-9]/}" ] && [ "$jumlah_item" -gt 0 ]; then
		:
	else
		echo "Jumlah item tidak valid!!"
	fi

	for ((i=1; i<=jumlah_item; i++)); do
		echo "Item ke-$i:"
		echo "Pilih menu (1-5): "
		read nomor
		if [[ -n "${menu[$nomor]+x}" ]]; then
			nama=${menu[$nomor]%%|*}
			harga=${menu[$nomor]#*|}
			echo "jumlah porsi : "
			read jumlah
			if [ -z "${jumlah//[0-9]/}" ] && [ "$jumlah" -gt 0 ]; then
				subtotal=$((harga * jumlah))
				pesanan["$nama"]="$jumlah|$subtotal"
				total_belanja=$((total_belanja + subtotal))
			else
				echo "jumlah porsi tidak valid!!"
				((i--))
			fi
		else
			echo "nomor menu tidak valid!!"
			((i--))
		fi
	done
	break
done

# Tampilkan ringkasan pesanan
if [ ${#pesanan[@]} -gt 0 ]; then
	echo -e "\ntotal belenja: Rp$total_belanja"
	echo "Masukkan jumlah uang : "
	read pembayaran
	if [ -z "${pembayaran//[0-9]/}" ] && [ "$pembayaran" -gt 0 ]; then
		if [ "$pembayaran" -ge "$total_belanja" ]; then 
			kembalian=$((pembayaran - total_belanja))
			echo "Kembalian: Rp$kembalian"
			echo "....Terima kasih telah berbelanja!!"
		else
			echo "Uang tidak cukup!"
		fi
	else
		echo "jumlah uang tidak valid!!"
	fi
else
	echo "Tidak ada pesanan yang dibuat."
fi

