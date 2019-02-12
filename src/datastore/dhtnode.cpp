/*
 *  Copyright (C) 2014-2017 Savoir-faire Linux Inc.
 *
 *  Authors: Adrien Béraud <adrien.beraud@savoirfairelinux.com>
 *           Simon Désaulniers <simon.desaulniers@savoirfairelinux.com>
 *           Sébastien Blin <sebastien.blin@savoirfairelinux.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

#include "tools_common.h"
extern "C" {
#include <gnutls/gnutls.h>
#include <vlog.h>
}

#include <set>
#include <thread> // std::this_thread::sleep_for

using namespace dht;

void print_node_info(const std::shared_ptr<DhtRunner>& dht, const dht_params& params) {
    vlogI("DataStore: node %s  running on port %d.", dht->getNodeId().to_c_str(), dht->getBoundPort());
    if (params.generate_identity)
        vlogI("DataStore: Public key ID %s.", dht->getId().to_c_str());
}

void request_loop(std::shared_ptr<DhtRunner>& dht, dht_params& params)
{
    while (true)
    {
        // using the GNU Readline API
        std::string line = readLine();
        if (!line.empty() && line[0] == '\0')
            break;

        std::istringstream iss(line);
        std::string op, idstr, value, index, keystr, pushServer, deviceKey;
        iss >> op;

        if (op == "x" || op == "exit" || op == "quit") {
            break;
        } else if (op == "h" || op == "help") {
            print_help();
            continue;
        } else if (op == "ll") {
            print_node_info(dht, params);
            std::cout << "IPv4 stats:" << std::endl;
            std::cout << dht->getNodesStats(AF_INET).toString() << std::endl;
            std::cout << "IPv6 stats:" << std::endl;
            std::cout << dht->getNodesStats(AF_INET6).toString() << std::endl;
            continue;
        } else if (op == "lr") {
            std::cout << "IPv4 routing table:" << std::endl;
            std::cout << dht->getRoutingTablesLog(AF_INET) << std::endl;
            std::cout << "IPv6 routing table:" << std::endl;
            std::cout << dht->getRoutingTablesLog(AF_INET6) << std::endl;
            continue;
        } else if (op == "ld") {
            iss >> idstr;
            InfoHash filter(idstr);
            if (filter)
                std::cout << dht->getStorageLog(filter) << std::endl;
            else
                std::cout << dht->getStorageLog() << std::endl;
            continue;
        } else if (op == "ls") {
            iss >> idstr;
            InfoHash filter(idstr);
            if (filter)
                std::cout << dht->getSearchLog(filter) << std::endl;
            else
                std::cout << dht->getSearchesLog() << std::endl;
            continue;
        } else if (op == "la")  {
            std::cout << "Reported public addresses:" << std::endl;
            auto addrs = dht->getPublicAddressStr();
            for (const auto& addr : addrs)
                std::cout << addr << std::endl;
            continue;
        } else if (op == "b") {
            iss >> idstr;
            try {
                auto addr = splitPort(idstr);
                if (not addr.first.empty() and addr.second.empty())
                    addr.second = std::to_string(DHT_DEFAULT_PORT);
                dht->bootstrap(addr.first.c_str(), addr.second.c_str());
            } catch (const std::exception& e) {
                std::cerr << e.what() << std::endl;
            }
            continue;
        } else if (op == "log") {
            iss >> idstr;
            InfoHash filter(idstr);
            params.log = filter == InfoHash{} ? !params.log : true;
            if (params.log)
                log::enableLogging(*dht);
            else
                log::disableLogging(*dht);
            dht->setLogFilter(filter);
            continue;
        } else if (op == "cc") {
            dht->connectivityChanged();
            continue;
        }

        if (op.empty())
            continue;

        static const std::set<std::string> VALID_OPS {"g", "l", "cl", "il", "ii", "p", "pp", "cpp", "s", "e", "a",  "q"};
        if (VALID_OPS.find(op) == VALID_OPS.cend()) {
            std::cout << "Unknown command: " << op << std::endl;
            std::cout << " (type 'h' or 'help' for a list of possible commands)" << std::endl;
            continue;
        }
        dht::InfoHash id;

        if (false) {}
        else {
            // Dht syntax
            iss >> idstr;
            id = dht::InfoHash(idstr);
            if (not id) {
                if (idstr.empty()) {
                    std::cerr << "Syntax error: invalid InfoHash." << std::endl;
                    continue;
                }
                id = InfoHash::get(idstr);
                std::cout << "Using h(" << idstr << ") = " << id << std::endl;
            }
        }

        // Dht
        auto start = std::chrono::high_resolution_clock::now();
        if (op == "g") {
            std::string rem;
            std::getline(iss, rem);
            dht->get(id, [start](std::shared_ptr<Value> value) {
                auto now = std::chrono::high_resolution_clock::now();
                std::cout << "Get: found value (after " << print_dt(now-start) << "s)" << std::endl;
                std::cout << "\t" << *value << std::endl;
                return true;
            }, [start](bool ok) {
                auto end = std::chrono::high_resolution_clock::now();
                std::cout << "Get: " << (ok ? "completed" : "failure") << " (took " << print_dt(end-start) << "s)" << std::endl;
            }, {}, dht::Where {std::move(rem)});
        }
        else if (op == "q") {
            std::string rem;
            std::getline(iss, rem);
            dht->query(id, [start](const std::vector<std::shared_ptr<FieldValueIndex>>& field_value_indexes) {
                auto now = std::chrono::high_resolution_clock::now();
                for (auto& index : field_value_indexes) {
                    std::cout << "Query: found field value index (after " << print_dt(now-start) << "s)" << std::endl;
                    std::cout << "\t" << *index << std::endl;
                }
                return true;
            }, [start](bool ok) {
                auto end = std::chrono::high_resolution_clock::now();
                std::cout << "Query: " << (ok ? "completed" : "failure") << " (took " << print_dt(end-start) << "s)" << std::endl;
            }, dht::Query {std::move(rem)});
        }
        else if (op == "l") {
            std::string rem;
            std::getline(iss, rem);
            auto token = dht->listen(id, [](const std::vector<std::shared_ptr<Value>>& values, bool expired) {
                std::cout << "Listen: found " << values.size() << " values" << (expired ? " expired" : "") << std::endl;
                for (const auto& value : values)
                    std::cout << "\t" << *value << std::endl;
                return true;
            }, {}, dht::Where {std::move(rem)});
            auto t = token.get();
            std::cout << "Listening, token: " << t << std::endl;
        }
        if (op == "cl") {
            std::string rem;
            iss >> rem;
            size_t token;
            try {
                token = std::stoul(rem);
            } catch(...) {
                std::cerr << "Syntax: cl [key] [token]" << std::endl;
                continue;
            }
            dht->cancelListen(id, token);
        }
        else if (op == "p") {
            std::string v;
            iss >> v;
            dht->put(id, dht::Value {
                dht::ValueType::USER_DATA.id,
                std::vector<uint8_t> {v.begin(), v.end()}
            }, [start](bool ok) {
                auto end = std::chrono::high_resolution_clock::now();
                std::cout << "Put: " << (ok ? "success" : "failure") << " (took " << print_dt(end-start) << "s)" << std::endl;
            });
        }
        else if (op == "pp") {
            std::string v;
            iss >> v;
            auto value = std::make_shared<dht::Value>(
                dht::ValueType::USER_DATA.id,
                std::vector<uint8_t> {v.begin(), v.end()}
            );
            dht->put(id, value, [start,value](bool ok) {
                auto end = std::chrono::high_resolution_clock::now();
                auto flags(std::cout.flags());
                std::cout << "Put: " << (ok ? "success" : "failure") << " (took " << print_dt(end-start) << "s). Value ID: " << std::hex << value->id << std::endl;
                std::cout.flags(flags);
            }, time_point::max(), true);
        }
        else if (op == "cpp") {
            std::string rem;
            iss >> rem;
            dht->cancelPut(id, std::stoul(rem, nullptr, 16));
        }
        else if (op == "s") {
            if (not params.generate_identity) {
                print_id_req();
                continue;
            }
            std::string v;
            iss >> v;
            dht->putSigned(id, dht::Value {
                dht::ValueType::USER_DATA.id,
                std::vector<uint8_t> {v.begin(), v.end()}
            }, [start](bool ok) {
                auto end = std::chrono::high_resolution_clock::now();
                std::cout << "Put signed: " << (ok ? "success" : "failure") << " (took " << print_dt(end-start) << "s)" << std::endl;
            });
        }
        else if (op == "e") {
            if (not params.generate_identity) {
                print_id_req();
                continue;
            }
            std::string tostr;
            std::string v;
            iss >> tostr >> v;
            dht->putEncrypted(id, InfoHash(tostr), dht::Value {
                dht::ValueType::USER_DATA.id,
                std::vector<uint8_t> {v.begin(), v.end()}
            }, [start](bool ok) {
                auto end = std::chrono::high_resolution_clock::now();
                std::cout << "Put encrypted: " << (ok ? "success" : "failure") << " (took " << print_dt(end-start) << "s)" << std::endl;
            });
        }
        else if (op == "a") {
            in_port_t port;
            iss >> port;
            dht->put(id, dht::Value {dht::IpServiceAnnouncement::TYPE.id, dht::IpServiceAnnouncement(port)}, [start](bool ok) {
                auto end = std::chrono::high_resolution_clock::now();
                std::cout << "Announce: " << (ok ? "success" : "failure") << " (took " << print_dt(end-start) << "s)" << std::endl;
            });
        }
    }

    std::cout << std::endl <<  "Stopping node..." << std::endl;
}

int
main(int argc, char **argv)
{
#ifdef WIN32_NATIVE
    gnutls_global_init();
#endif

    auto dht = std::make_shared<DhtRunner>();

    try {
        auto params = parseArgs(argc, argv);
        if (params.help) {
            print_usage();
            return 0;
        }

        if (params.daemonize) {
            daemonize();
        } else if (params.service) {
            setupSignals();
        }

        dht::crypto::Identity crt {};
        if (params.generate_identity) {
            auto ca_tmp = dht::crypto::generateEcIdentity("DHT Node CA");
            crt = dht::crypto::generateIdentity("DHT Node", ca_tmp);
        }

        dht::DhtRunner::Config config {};
        config.dht_config.node_config.network = params.network;
        config.dht_config.node_config.maintain_storage = false;
        config.dht_config.id = crt;
        config.threaded = true;
        config.proxy_server = params.proxyclient;
        config.push_node_id = "dhtnode";
        if (not params.proxyclient.empty())
            dht->setPushNotificationToken(params.devicekey);

        dht->run(params.port, config);

        if (params.log) {
            if (params.syslog or (params.daemonize and params.logfile.empty()))
                log::enableSyslog(*dht, "dhtnode");
            else if (not params.logfile.empty())
                log::enableFileLogging(*dht, params.logfile);
            else
                log::enableLogging(*dht);
        }

        if (not params.bootstrap.first.empty()) {
            //std::cout << "Bootstrap: " << params.bootstrap.first << ":" << params.bootstrap.second << std::endl;
            dht->bootstrap(params.bootstrap.first.c_str(), params.bootstrap.second.c_str());
        }

        if (params.proxyserver != 0) {
            std::cerr << "DHT proxy server requested but OpenDHT built without proxy server support." << std::endl;
            exit(EXIT_FAILURE);
        }

        print_node_info(dht, params);

        if (params.daemonize or params.service)
            while (runner.wait());
        else
            cmd_loop(dht, params);

    } catch(const std::exception&e) {
        std::cerr << std::endl <<  e.what() << std::endl;
    }

    std::condition_variable cv;
    std::mutex m;
    std::atomic_bool done {false};

    dht->shutdown([&]()
    {
        std::lock_guard<std::mutex> lk(m);
        done = true;
        cv.notify_all();
    });

    // wait for shutdown
    std::unique_lock<std::mutex> lk(m);
    cv.wait(lk, [&](){ return done.load(); });

    dht->join();
#ifdef WIN32_NATIVE
    gnutls_global_deinit();
#endif
    return 0;
}
