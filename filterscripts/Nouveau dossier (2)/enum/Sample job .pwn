
// ------------------------------------------
enum // id pekerjaan (resmi)
{
	JOB_BUS_DRIVER = 1, // supir bus
	JOB_TAXI_DRIVER,	// supir taksi
	JOB_MECHANIC,		// montir
	JOB_TRUCKER			// sopir truk
};

// ------------------------------------------
enum // PICKUP ACTION
{
	PICKUP_ACTION_APOTEK,          //PEMBELIAN OBAT SAKIT
	PICKUP_ACTION_TYPE_TELEPORT = 1, 	// Teleportasi (pintu masuk/keluar)
	PICKUP_ACTION_TYPE_ATM,				// ATM
	PICKUP_ACTION_BUAT_SENJATA,               //PEMBELIAN LIC SENJATA
	PICKUP_ACTION_TYPE_MANCING,         // Mancing
	PICKUP_ACTION_TYPE_BANK, 			// bank
	PICKUP_ACTION_TYPE_SENJATA_ILEGAL,  //
	PICKUP_ACTION_BANDARA_LS,               //Traveling
	PICKUP_ACTION_BANDARA_LV,               //Traveling
	PICKUP_ACTION_BANDARA_SF,               //Traveling
	PICKUP_ACTION_MEKANIK,
	PICKUP_ACTION_MEKANIK1,
	PICKUP_ACTION_KOLAM,
    PICKUP_ACTION_MASUK_KOLAM,
	PICKUP_ACTION_TYPE_TEMP_JOB, 		// pekerjaan sementara
	PICKUP_ACTION_TYPE_INFO_PICKUP, 	// info pengambilan
	PICKUP_ACTION_TYPE_MINER_SELL_M, 	// pembelian tambang
	PICKUP_ACTION_TYPE_FACTORY_MET,		// ambil logam (tanaman)
	PICKUP_ACTION_TYPE_FUEL_STATION,	// membeli tabung gas
	PICKUP_ACTION_TYPE_BIZ_ENTER,		// entri bisnis
	PICKUP_ACTION_TYPE_BIZ_EXIT,		// masuk ke bisnis
	PICKUP_ACTION_TYPE_BIZ_HEALTH,		// kotak P3K dalam bisnis
	PICKUP_ACTION_TYPE_BIZ_SHOP_247,	// beli di 24\7
	PICKUP_ACTION_TYPE_CELL_SALON,		// beli di salon sel
	PICKUP_ACTION_TYPE_BIZ_MC,	// snack bar
	PICKUP_ACTION_TYPE_BIZ_SHOP_GUN,	// toko senjata
	PICKUP_ACTION_TYPE_BIZ_DRIVER, // sekolah mengemudi
	PICKUP_ACTION_TYPE_HOUSE,			// pintu masuk ke rumah
	PICKUP_ACTION_TYPE_HOUSE_HEALTH,	// kotak P3K di rumah
	PICKUP_ACTION_TYPE_REALTOR_HOME,	// agen real estat
	PICKUP_ACTION_TYPE_BIZ_CLOTHING,	// toko pakaian
	PICKUP_ACTION_TYPE_HOTEL_ROOM,		// kamar hotel
	PICKUP_ACTION_TYPE_BIZ_CAR_MARK,	// pembelian mobil
	PICKUP_ACTION_TYPE_BIZ_CAR_ENT,		// teleport ke pintu masuk ke pasar mobil
	PICKUP_ACTION_TYPE_BIZ_CAR_EXI,		// teleport untuk keluar dari pasar mobil
	PICKUP_ACTION_TYPE_GET_CAR_NUM,		// mendapatkan nomor pada kendaraan
	PICKUP_ACTION_TYPE_MINER_CARRI,		// truk pickup
	PICKUP_ACTION_TYPE_GANG_REPOSIT,	// gudang untuk geng
	PICKUP_ACTION_TYPE_ARMORY,			// gudang senjata
	PICKUP_ACTION_TYPE_BIZ_CAR_TUN,		// penyetelan transportasi
	PICKUP_ACTION_TYPE_MAYOR_JOB,        // pekerjaan
	PICKUP_ACTION_TYPE_MAYOR_PASS,        // Mendapatkan paspor
	PICKUP_ACTION_TYPE_GET_FAMILY,      // menciptakan keluarga
	PICKUP_ACTION_TYPE_PUT_PROD,        // produk awam
	PICKUP_ACTION_TYPE_SELL_FISH,       // penjualan ikan
	PICKUP_ACTION_TYPE_CHANGESKIN,      // perubahan kulit fraksi
	PICKUP_ACTION_TYPE_RENT_TRUCK,      // sewa truk
//	PICKUP_ACTION_TYPE_GIFT,            // Penjemputan sepatu kuda
//	PICKUP_ACTION_TYPE_SELL_GIFT,       // penjualan sepatu kuda
	PICKUP_ACTION_BUYLIC,               // Membeli lisensi bisnis
	PICKUP_ACTION_RENT_BOARD,           // Penyewaan papan iklan.
	PICKUP_ACTION_TYPE_CASINO_FORT,  // Kasino Roulette
	PICKUP_ACTION_TYPE_SPORTZAL,        // Gym
	PICKUP_ACTION_TYPE_SET_HINT,        // pembelian furnitur
	PICKUP_ACTION_GET_MED,              // Mendapatkan bantuan madu
	PICKUP_ACTION_PASS_PHOTO,           // Foto paspor
	PICKUP_ACTION_BUY_NARKO,            // Pembelian obat-obatan
	PICKUP_ACTION_RENT_BIKE,            // Sewa lasoped
	PICKUP_ACTION_FORKLIFT,             //JOB FORKLIFT
	PICKUP_ACTION_KERJA_FORKLIFT,        //JOB FORKLIFT
    PICKUP_ACTION_LEGALL,               //JOB PAKET LEGALL
    PICKUP_ACTION_SELESAI_LEGALL,       //JOB PAKET LEGALL
    PICKUP_ACTION_RENT_KENDARAAN,       //RENTAL KENDARAAN
    PICKUP_ACTION_BANK_KIRP,
    PICKUP_ACTION_TYPE_BANK_KIRP,
	PICKUP_ACTION_SWEPER_SAPI,          //PERAS SUSU
	PICKUP_ACTION_SELESAI_SAPI,         //PERAS SUSU
	PICKUP_ACTION_SWEPER_BAJU,			 //PEMBERSIH JALAN
	PICKUP_ACTION_SELESAI_SWEPER,       //PEMBERSIH JALAN
	PICKUP_ACTION_BLACK_MARKET,         //BLACK MARKET
	PICKUP_ACTION_CALLUMUM,             //TELFON UMUM
	PICKUP_ACTION_START_HAULINGS,       //JOB HAULING
	PICKUP_ACTION_FINISH_HAULING,        //JOB HAULING
	PICKUP_ACTION_RENT_KAPAL,           //PENYEWAAN KAPAL
 	PICKUP_ACTION_RENT_MOTOR,
 	PICKUP_ACTION_RENT_TRUK,
	PICKUP_ACTION_KERJA_BENSIN,         //JOB BENSIN
	PICKUP_ACTION_SELESAI_BENSIN,       //JOB BENSIN
	PICKUP_ACTION_START_KONTAINER,      //JOB KONTAINER
	PICKUP_ACTION_START_PILOT,
	PICKUP_ACTION_FINISH_PILOT,
	PICKUP_ACTION_FINISH_KONTAINER,     //JOB KONTAINER
	PICKUP_ACTION_TRAVELING,            //TRAVELLING BUS
	PICKUP_ACTION_MULAI_TRASH,          //JOB TRASHMASTER
	PICKUP_ACTION_SELESAI_TRASH,        //JOB TRASHMASTER
	PICKUP_ACTION_START_PENYU,          //JOB PENYU
	PICKUP_ACTION_FINISH_PENYU,        //JOB PENYU
	PICKUP_ACTION_MULAI_KULI,           //JOB KULI BANGUNAN
	PICKUP_ACTION_SELESAI_KULI,         //JOB KULI BANGUNAN
	PICKUP_ACTION_PETIK_APEL,           //JOH PETIK APEL
	PICKUP_ACTION_SELESAI_APEL,         //JOB PETIK APEL
	PICKUP_ACTION_RENT_LSPD,            //RENT LSPD
	PICKUP_ACTION_RENT_FBI,             //KENDARAAN FBI
	PICKUP_ACTION_RENT_LVPD,             //KENDARAAN LVPD
	PICKUP_ACTION_ROB_MOBIL,              //ROB MOBIL IMPORT
	PICKUP_ACTION_GARKOT,               // Garasi gta5
	PICKUP_ACTION_MASUK_AYAM,
	PICKUP_ACTION_KELUAR_AYAM,
	PICKUP_ACTION_ELECTRIC_JOIN,
	PICKUP_ACTION_ELECTRIC_EXIT,
	PICKUP_ACTION_ROB_CAR,              //ROB MOBIL IMPORT
	PICKUP_ACTION_ROB_EMAS,               //ROB EMAS BATANGAN
	PICKUP_ACTION_CREATE_JAY,               //PEMBELIAN OBAT SAKIT
	PICKUP_ACTION_ROB_MOTOR,              //ROB MOTOR IMPORT
	PICKUP_ACTION_GUDANG_MEKA,          //GUDAJG MEKA
};

enum // jenis mobil
{
	VEHICLE_ACTION_TYPE_DRIVING_SCH = 1, // Transportasi pelatihan (untuk hak)
	VEHICLE_ACTION_TYPE_OWNABLE_CAR,	// transportasi pribadi
	VEHICLE_ACTION_TYPE_FACTORY, 		// tanaman (jasa pengiriman)
	VEHICLE_ACTION_TYPE_BUS_DRIVER,		// Sopir bus
	VEHICLE_ACTION_TYPE_TAXI_DRIVER,	// Supir taksi
	VEHICLE_ACTION_TYPE_MECHANIC,		// Mekanik otomatis
	VEHICLE_ACTION_TYPE_TRUCKER,		// Pengemudi truk (produk)
	VEHICLE_ACTION_TYPE_RENT_CAR,		// Kendaraan untuk disewakan
	VEHICLE_ACTION_TYPE_GOV_CAR,		// Mobil pemerintah
	VEHICLE_ACTION_TYPE_ARMY_CAR,		// Mobil unit militer
	VEHICLE_ACTION_TYPE_MED_CAR,		// Mobil Rumah Sakit
	VEHICLE_ACTION_TYPE_RADIO_CAR,		// Mobil Radio Center
	VEHICLE_ACTION_TYPE_LSPD_CAR,		// Mobil LSPD
	VEHICLE_ACTION_TYPE_FBI_CAR,		// Mobil FBI
	VEHICLE_ACTION_TYPE_LVPD_CAR,       // Mobil Lvpd
	VEHICLE_ACTION_TYPE_GROVE_CAR,		// Mobil Grove
	VEHICLE_ACTION_TYPE_JOBS_PILOT,
	VEHICLE_ACTION_TYPE_VAGOS_CAR,		// Mobil Vagos
	VEHICLE_ACTION_TYPE_BALLAS_CAR,		// Mobil Ballas
	VEHICLE_ACTION_TYPE_AZTECAS_CAR,    // Mobil Aztecov
	VEHICLE_ACTION_TYPE_BROKER_CAR,     // Mobil Jefferson20's
	VEHICLE_ACTION_TYPE_ADMIN_CAR,		// Transportasi, dibuat oleh administrator
	VEHICLE_ACTION_TYPE_COMBAIN,        // Gabungkan Pemanen
	VEHICLE_ACTION_TYPE_TRUCK,    		// Pengemudi truk (kontrak)
	VEHICLE_ACTION_TYPE_TRUCK_TRAIL,    // Trailer pengemudi truk
	VEHICLE_ACTION_TYPE_RENT_BIKE,      //PENYEWAAN SEPEDA
 	VEHICLE_ACTION_TYPE_RENT_LRP,       //RENTAL MOBIL
 	VEHICLE_ACTION_TYPE_RENT_KAPAL,     //PENYEWAAN KAPAL
    VEHICLE_ACTION_TYPE_RENT_MOTOR,
    VEHICLE_ACTION_TYPE_RENT_TRUK,
 	VEHICLE_ACTION_TYPE_RENT_LSPD,     //KENDARAAN LSPD
 	VEHICLE_ACTION_TYPE_RENT_FBI,     //KENDARAAN FB
 	VEHICLE_ACTION_TYPE_RENT_LVPD,     //KENDARAAN LVPD
};
