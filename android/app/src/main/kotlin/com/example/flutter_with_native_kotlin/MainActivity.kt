package com.example.flutter_with_native_kotlin

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import com.google.android.gms.tasks.CancellationToken
import com.google.android.gms.tasks.CancellationTokenSource
import com.google.android.gms.tasks.OnTokenCanceledListener
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "my_app/method/location"
    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "getNativeLocation") {
                fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
                //Verificar se o usuário tem Google Play
                if (GoogleApiAvailability().isGooglePlayServicesAvailable(this) == ConnectionResult.SUCCESS) {
                    //Verificar se o usuário deu permissão
                    if (ActivityCompat.checkSelfPermission(
                            this,
                            Manifest.permission.ACCESS_FINE_LOCATION
                        ) == PackageManager.PERMISSION_GRANTED
                        && ActivityCompat.checkSelfPermission(
                            this,
                            Manifest.permission.ACCESS_COARSE_LOCATION
                        ) == PackageManager.PERMISSION_GRANTED
                    ) {
                        val locationManager =
                            this@MainActivity.getSystemService(Context.LOCATION_SERVICE) as LocationManager
                        val isGpsEnabled =
                            locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
                        //Verificar se ele tem e GPS
                        if (isGpsEnabled) {
                            fusedLocationClient.getCurrentLocation(
                                Priority.PRIORITY_HIGH_ACCURACY,
                                object : CancellationToken() {
                                    override fun onCanceledRequested(p0: OnTokenCanceledListener) =
                                        CancellationTokenSource().token

                                    override fun isCancellationRequested() = false
                                })
                                .addOnSuccessListener { location: Location? ->
                                    location?.let {
                                        result.success("{\"LONGITUDE\":\"${it.longitude}\",\"LATITUDE\":\"${it.latitude}\"}")
                                    }
                                }
                        } else {
                            result.error("Unavailable", "GPS desabilitado", null)
                        }
                    } else {
                        val permissions = arrayOf(
                            Manifest.permission.ACCESS_FINE_LOCATION,
                            Manifest.permission.ACCESS_COARSE_LOCATION
                        )
                        ActivityCompat.requestPermissions(
                            this,
                            permissions,
                            99
                        )
                    }
                } else {
                    result.error("Unavailable", "Problema na Play Store", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
